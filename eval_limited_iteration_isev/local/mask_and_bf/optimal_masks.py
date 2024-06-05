import argparse
import os

import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
from tqdm import tqdm
import sys
from distutils.util import strtobool

from chime_data import gen_flist_simu, gen_flist_2ch,\
    gen_flist_real, get_audio_data, get_audio_data_1ch, get_audio_data_with_context
from bf.signal_processing import audiowrite, stft, istft
from bf.utils import Timer
from bf.utils import mkdir_p
import bf.beamforming

MARKER_SIZE = 10

import matplotlib
matplotlib.use('TkAgg')
from matplotlib import pylab as pl
import nn_models
def plot_specgrams(X, masks, Y, S, N, fig_no=0):
    X = np.abs(to_np(X))
    Y = np.abs(to_np(Y))
    S = np.abs(to_np(S))
    N = np.abs(to_np(N))
    masks = np.abs(to_np(masks))
    num_masks = masks.shape[1]

    fig = pl.figure(fig_no)
    fig.clf()
    ax = fig.add_subplot(3, 3, 1)
    nn_models.imshow_specgram(ax, S.T, 'hot')
    ax.set_title('Target')

    ax = fig.add_subplot(3, 3, 4)
    nn_models.imshow_specgram(ax, N.T, 'hot')
    ax.set_title('Jammer')

    ax = fig.add_subplot(3, 3, 7)
    nn_models.imshow_specgram(ax, X.T, 'hot')
    ax.set_title('Observation')

    if num_masks > 0:
        m = masks[:,0]
        m /= np.max(m,axis=0,keepdims=True)
        vmax = 1
        #vmax = np.median(m) * 3
        #vmax = np.median(m)
        #vmax = np.max(m) / 2
        ax = fig.add_subplot(3, 3, 2)
        ax.imshow(m.T, origin="lower", aspect="auto", cmap='gray', vmin=0, vmax=vmax)
        ax.set_title('Mask1')
        ax = fig.add_subplot(3, 3, 3)
        nn_models.imshow_specgram(ax, (X*m).T, 'hot')
        ax.set_title('Observation*mask1')

    if num_masks > 1:
        m = masks[:,1]
        m /= np.max(m,axis=0,keepdims=True)
        vmax = 1
        #vmax = np.median(m) * 3
        #vmax = np.median(m)
        #vmax = np.max(m) / 2
        #vmax = np.max(m) / 2
        ax = fig.add_subplot(3, 3, 5)
        ax.imshow(m.T, origin="lower", aspect="auto", cmap='gray', vmin=0, vmax=vmax)
        ax.set_title('Mask2')
        ax = fig.add_subplot(3, 3, 6)
        nn_models.imshow_specgram(ax, (X*m).T, 'hot')
        ax.set_title('Observation*mask2')

    ax = fig.add_subplot(3, 3, 9)
    nn_models.imshow_specgram(ax, Y.T, 'hot')
    ax.set_title('BF output')

    ax = fig.add_subplot(3, 3, 8)
    Y_nor = Y / np.sqrt(np.mean(Y*Y, axis=0, keepdims=True))
    nn_models.imshow_specgram(ax, Y_nor.T, 'hot')
    ax.set_title('Normalized BF output')


    fig.tight_layout()
    #pl.pause(0.00001)
    #input('Hit ENTER')
    #pl.show()

def scatter_plot(mask, S, N, Y, X, fig_no=1, marker='o'):
    mask = np.abs(to_np(mask))
    S_abs = normalize(np.abs(to_np(S)))
    N_abs = normalize(np.abs(to_np(N)))
    Y_abs = normalize(np.abs(to_np(Y)))
    X_abs = normalize(np.abs(to_np(X)))
    fig = pl.figure(fig_no)
    fig.clf()

    ax = fig.add_subplot(3, 3, 1)
    y_data = (S_abs).flatten()
    x_data = (mask).flatten()
    ax.scatter(x=x_data, y=y_data, marker=marker, s=MARKER_SIZE, alpha=0.5, linewidths=1, c='#aaaaFF', edgecolors='b')
    ax.set_ylabel('Normalized |Target|')
    ax.set_xlabel('Weight')
    ax.set_ylim([0, np.max(y_data)])
    ax.set_xlim([0, np.max(x_data)])
    #ax.set_xlim([0, 10])

    ax = fig.add_subplot(3, 3, 2)
    y_data = (S_abs / X_abs).flatten()
    x_data = (mask).flatten()
    ax.scatter(x=x_data, y=y_data, marker=marker, s=MARKER_SIZE, alpha=0.5, linewidths=1, c='#aaaaFF', edgecolors='b')
    ax.set_ylabel('|Target|/|Observation|')
    ax.set_xlabel('Weight')
    ax.set_ylim([0, np.max(y_data)])
    ax.set_xlim([0, np.max(x_data)])
    #ax.set_ylim([0, 100])
    #ax.set_xlim([0, 10])

    ax = fig.add_subplot(3, 3, 3)
    y_data = (S_abs / N_abs).flatten()
    x_data = (mask).flatten()
    ax.scatter(x=x_data, y=y_data, marker=marker, s=MARKER_SIZE, alpha=0.5, linewidths=1, c='#aaaaFF', edgecolors='b')
    ax.set_ylabel('|Target|/|Jammer|')
    ax.set_xlabel('Weight')
    ax.set_ylim([0, np.max(y_data)])
    ax.set_xlim([0, np.max(x_data)])
    #ax.set_ylim([0, 1000])
    #ax.set_xlim([0, 10])

    ax = fig.add_subplot(3, 3, 4)
    y_data = (N_abs).flatten()
    x_data = (mask).flatten()
    ax.scatter(x=x_data, y=y_data, marker=marker, s=MARKER_SIZE, alpha=0.5, linewidths=1, c='#aaaaFF', edgecolors='b')
    ax.set_ylabel('Normalized |Jammer|')
    ax.set_xlabel('Weight')
    ax.set_ylim([0, np.max(y_data)])
    ax.set_xlim([0, np.max(x_data)])
    #ax.set_xlim([0, 10])

    ax = fig.add_subplot(3, 3, 5)
    y_data = (N_abs / X_abs).flatten()
    x_data = (mask).flatten()
    ax.scatter(x=x_data, y=y_data, marker=marker, s=MARKER_SIZE, alpha=0.5, linewidths=1, c='#aaaaFF', edgecolors='b')
    ax.set_ylabel('|Jammer|/|Observation|')
    ax.set_xlabel('Weight')
    ax.set_ylim([0, np.max(y_data)])
    ax.set_xlim([0, np.max(x_data)])
    #ax.set_ylim([0, 100])
    #ax.set_xlim([0, 10])

    ax = fig.add_subplot(3, 3, 6)
    y_data = (N_abs / S_abs).flatten()
    x_data = (mask).flatten()
    ax.scatter(x=x_data, y=y_data, marker=marker, s=MARKER_SIZE, alpha=0.5, linewidths=1, c='#aaaaFF', edgecolors='b')
    ax.set_ylabel('|Jammer|/|Target|')
    ax.set_xlabel('Weight')
    ax.set_ylim([0, np.max(y_data)])
    ax.set_xlim([0, np.max(x_data)])
    #ax.set_ylim([0, 1000])
    #ax.set_xlim([0, 10])

    ax = fig.add_subplot(3, 3, 7)
    y_data = (Y_abs).flatten()
    x_data = (mask).flatten()
    ax.scatter(x=x_data, y=y_data, marker=marker, s=MARKER_SIZE, alpha=0.5, linewidths=1, c='#aaaaFF', edgecolors='b')
    ax.set_ylabel('Normalized |Extraction|')
    ax.set_xlabel('Weight')
    ax.set_ylim([0, np.max(y_data)])
    ax.set_xlim([0, np.max(x_data)])
    #ax.set_xlim([0, 10])

    ax = fig.add_subplot(3, 3, 8)
    y_data = (Y_abs / X_abs).flatten()
    x_data = (mask).flatten()
    ax.scatter(x=x_data, y=y_data, marker=marker, s=MARKER_SIZE, alpha=0.5, linewidths=1, c='#aaaaFF', edgecolors='b')
    ax.set_ylabel('|Extraction|/|Observation|')
    ax.set_xlabel('Weight')
    ax.set_ylim([0, np.max(y_data)])
    ax.set_xlim([0, np.max(x_data)])
    #ax.set_ylim([0, 100])
    #ax.set_xlim([0, 10])

    fig.tight_layout()


def scatter_plot_some_bins(mask, S, N, Y, X, fig=2, marker='o'):
    mask = np.abs(mask)
    S_abs = normalize(np.abs(S))
    N_abs = normalize(np.abs(N))
    Y_abs = normalize(np.abs(Y))
    X_abs = normalize(np.abs(X))
    figure = pl.figure(fig)
    figure.clf()

    bins = S.shape[-1]
    freqs = (0, 250, 500, 1000, 2000, 4000, 8000)
    #freqs = (0, 125, 250, 500, 1000, 2000, 8000)

    y_data = S_abs
    x_data = mask
    for i in range(1, len(freqs)):
        ax = figure.add_subplot(3, len(freqs), i+1)
        begin_freq = freqs[i-1]
        end_freq = freqs[i]
        begin_idx = int(bins * begin_freq/8000)
        end_idx = int(bins * end_freq/8000)
        label = '{}-{}Hz'.format(begin_freq, end_freq)
        ax.scatter(x_data[:,begin_idx:end_idx], y_data[:,begin_idx:end_idx], s=MARKER_SIZE, alpha=0.5, linewidths=1, label=label)
        ax.set_xlim([0, np.max(x_data)])
        ax.set_ylim([0, np.max(y_data)])
        ax.legend()

    y_data = N_abs
    x_data = mask
    for i in range(1, len(freqs)):
        ax = figure.add_subplot(3, len(freqs), i+1+len(freqs))
        begin_freq = freqs[i-1]
        end_freq = freqs[i]
        begin_idx = int(bins * begin_freq/8000)
        end_idx = int(bins * end_freq/8000)
        label = '{}-{}Hz'.format(begin_freq, end_freq)
        ax.scatter(x_data[:,begin_idx:end_idx], y_data[:,begin_idx:end_idx], s=MARKER_SIZE, alpha=0.5, linewidths=1, label=label)
        ax.set_xlim([0, np.max(x_data)])
        ax.set_ylim([0, np.max(y_data)])
        ax.legend()

    y_data = Y_abs
    x_data = mask
    for i in range(1, len(freqs)):
        ax = figure.add_subplot(3, len(freqs), i+1+len(freqs)*2)
        begin_freq = freqs[i-1]
        end_freq = freqs[i]
        begin_idx = int(bins * begin_freq/8000)
        end_idx = int(bins * end_freq/8000)
        label = '{}-{}Hz'.format(begin_freq, end_freq)
        ax.scatter(x_data[:,begin_idx:end_idx], y_data[:,begin_idx:end_idx], s=MARKER_SIZE, alpha=0.5, linewidths=1, label=label)
        ax.set_xlim([0, np.max(x_data)])
        ax.set_ylim([0, np.max(y_data)])
        ax.legend()

    figure.tight_layout()

def normalize(x):
    var = np.mean(x*np.conj(x), axis=0, keepdims=True).real
    return x / np.sqrt(var)

def to_np(x):
    return x.cpu().detach().numpy().copy()


MODE_TO_MASK_NUM = {
    'both': 2,
    'left': 1,
    'right': 1,
}


class MaskBfEstimator(nn.Module):
    def __init__(self, bins, frames, channels, mode, scaling, target_ch, do_bn):
        super().__init__()
        masks_num = MODE_TO_MASK_NUM[mode]
        masks = torch.randn((frames, masks_num, bins), dtype=torch.float)
        self.masks = nn.parameter.Parameter(masks)
        self.bins = bins
        self.frames = frames
        self.channels = channels
        self.mode = mode
        self.target_ch = target_ch
        self.scaling_method = scaling
        self.scaling_mask = None
        if scaling in ('mask', 'normask', 'absmask'):
            mask = torch.randn((frames, 1, bins), dtype=torch.float)
            self.scaling_mask = nn.parameter.Parameter(mask)
        if do_bn:
            self.bn_for_filter = torch.nn.BatchNorm1d(bins*masks_num)
            self.bn_for_scale = torch.nn.BatchNorm1d(bins)
        else:
            self.bn_for_filter = None
            self.bn_for_scale = None

    def get_normalized_masks(self):
        masks = self._apply_bn(self.masks, self.bn_for_filter)
        return masks.sigmoid()

    def get_scaling_mask(self):
        mask = self._apply_bn(self.scaling_mask, self.bn_for_scale)
        if self.scaling_method in ('mask', 'normask'):
            mask = mask.sigmoid()
            if self.scaling_method == 'normask':
                mean_mask = mask.mean(dim=0,keepdim=True)
                mask = mask / mean_mask
        elif self.scaling_method == 'absmask':
            mask = mask.abs()
        return mask

    def _apply_bn(self, x, bn):
        if x is not None and bn is not None:
            (frames,masks_num,_) = x.shape
            x = x.reshape(frames, -1)
            x = bn(x)
            x = x.reshape(frames, masks_num, -1)
        return x

    def calc_scaled_bf(self, x, s):
        bf_out = self._mask_based_bf(x, s)
        return bf_out

    def calc_loss(self, X, S):
        """
        X.shape = S.shape = (frames, mics, bins)
        """
        ch = self.target_ch
        bf_scaled = self._mask_based_bf(X, S)   # shape: (frames, 1, bins)
        S_target = S[:,ch:ch+1]   # shape: (frames, 1, bins)
        diff = bf_scaled - S_target
        S_sqmean = torch.mean(self._square(S_target), dim=0, keepdim=True)
        loss = torch.mean(self._square(diff) / S_sqmean)
        return loss

    def _mask_based_bf(self, x, s):
        """
        x: observation spectrograms. shape: (frames, mics, bins), where N is batch size.
        s: multichannel target signals: (frames, mics, bins)

        output: BF result(s). shape: (frames, 1, bins)
        """
        frames = x.shape[0]   # x.shape = (frames, channels, bins)
        x = x.T
        s = s.T
        ch = self.target_ch

        masks = self.get_normalized_masks().T
        if self.mode == 'both':
            wcov1 = self._calc_wcov(x, masks[:,0,:])
            wcov2 = self._calc_wcov(x, masks[:,1,:])
        elif self.mode == 'left':
            wcov1 = self._calc_wcov(x, masks[:,0,:])
            wcov2 = torch.matmul(x, self._htp(x)) / frames
        elif self.mode == 'right':
            wcov1 = torch.matmul(x, self._htp(x)) / frames
            wcov2 = self._calc_wcov(x, masks[:,0,:])
        else:
            raise ValueError('Unknown mode:', self.mode)
        # Calculate the steering vector as the primary eigenvector of wcov2
        vals, vecs = torch.linalg.eigh(wcov2)
        h = vecs[:,:,-1:]
        w = torch.linalg.solve(wcov1, h)  # w <-- inv(wcov1) h
        y = torch.matmul(self._htp(w), x)
        scaling_target = self._get_scaling_target(x, s)
        if scaling_target is not None:
            y = self._rescale(y, scaling_target)

        return y.T


    def _get_scaling_target(self, x, s):
        ch = self.target_ch
        if self.scaling_method in ('mask', 'normask', 'absmask'):
            mask = self.get_scaling_mask()
            return mask.T * x[:,ch:ch+1]
        elif self.scaling_method == 'ideal':
            return s[:,ch:ch+1]
        elif self.scaling_method == 'mdp':
            return x[:,ch:ch+1]
        else:
            return None


    def _calc_wcov(self, x, m):
        frames = x.shape[-1]
        m_3d = self._to_3d(m)
        return torch.matmul(m_3d*x, self._htp(x)) / frames

    def _square(self, x):
        return (x * x.conj()).real

    def _rescale(self, y, rescale_target):
        cov = torch.matmul(rescale_target, self._htp(y))
        var = torch.matmul(y, self._htp(y))
        scale = cov / var
        return y * scale

    def _htp(self, x):
        return x.swapaxes(-1, -2).conj()

    def _to_2d(self, x):
        return x.squeeze(-2)

    def _to_3d(self, x):
        return x.unsqueeze(-2)



parser = argparse.ArgumentParser(description='Weighted minimum variance BF')
parser.add_argument('flist',
                    help='Name of the flist to process (e.g. tr05_simu)')
parser.add_argument('chime_dir',
                    help='Base directory of the CHiME challenge.')
parser.add_argument('sim_dir',
                    help='Base directory of the CHiME challenge simulated data.')
parser.add_argument('output_dir',
                    help='The directory where the enhanced wav files will '
                         'be stored.')
parser.add_argument('--gpu', '-g', default=-1, type=int,
                    help='GPU ID (negative value indicates CPU)')
#parser.add_argument('--single', '-s', default=0, type=int,
#                    help='0 for multi-channel and channel number (1-6) for single channel')
parser.add_argument('--track', '-t', default=6, type=int,
                    help='1, 2 or 6 depending on the data used')
parser.add_argument('--target_mic', '-m', default=5, type=int,
                    help='Index of target microphone')
parser.add_argument('--max_epochs', default=200, type=int,
                    help='Max. number of epochs to train')
parser.add_argument('--max_frames', default=None, type=int,
                    help='Max. number of frames of a spectrogram')
parser.add_argument('--bg_gain', default=1., type=float,
                    help='Gain for background noise.')
parser.add_argument('--plot', '-p', default=False, type=strtobool,
                    help='Display spectrograms of observation and estimated target source')
parser.add_argument('--do_bn', default=True, type=strtobool,
                    help='Enable batch normalization')
parser.add_argument('--mode',
                    help='Mode. (both|left|right)')
parser.add_argument('--scaling',
                    help='Scaling method. (mask|mdp|ideal|normask|absmask|none)')
args = parser.parse_args()


if args.track != 6:
    raise ValueError('Only track=6 case is supported.')

if args.mode not in MODE_TO_MASK_NUM:
    raise ValueError('Unknoen mode:', args.mode)
if args.scaling not in ('mask', 'mdp', 'ideal', 'normask', 'absmask', 'none'):
    raise ValueError('Unknoen scaling method:', args.scaling)


stage = args.flist[:2]
scenario = args.flist.split('_')[-1]

if stage == 'tr' and (args.track == 1 or args.track == 2):
    print("No train data for 1ch track and 2ch track")
    sys.exit(0)

# CHiME data handling
if scenario == 'simu':
    if args.track == 6:
        flist = gen_flist_simu(args.chime_dir, args.sim_dir, stage, ext=True)
    else:
        raise ValueError('Only case of track=6 is supported.')
else:
    raise ValueError('Unknown flist {}'.format(args.flist))

for env in ['caf', 'bus', 'str', 'ped']:
    mkdir_p(os.path.join(args.output_dir, '{}05_{}_{}'.format(
            stage, env, scenario
    )))

target_ch = args.target_mic - 1

t_io = 0
t_fw = 0
t_bw = 0
t_net = 0

last_idx = len(flist)
#last_idx = min(5, last_idx)
# Beamform loop
#for cur_line in tqdm(flist):
for cur_line in tqdm(flist[:last_idx]):
    print(cur_line)
    with Timer() as t:
        if args.track == 6:
            if scenario == 'simu':
                audio_data_clean = get_audio_data(cur_line, postfix='.Clean')
                audio_data_noise = get_audio_data(cur_line, postfix='.Noise')
                audio_data_noise *= args.bg_gain
                audio_data = audio_data_clean + audio_data_noise
                context_samples = 0
            elif scenario == 'real':
                raise ValueError('Scenario \'real\' is not supported.')
        else:
            raise ValueError('Case of track=1 is not supported. Specify 2 or 6.')
    t_io += t.msecs
    X = stft(audio_data, time_dim=1).transpose((1, 0, 2))
    S = stft(audio_data_clean, time_dim=1).transpose((1, 0, 2))
    N = stft(audio_data_noise, time_dim=1).transpose((1, 0, 2))
    if args.max_frames is not None:
        X = X[:args.max_frames]
        S = S[:args.max_frames]
        N = N[:args.max_frames]
    X = torch.from_numpy(X.astype(np.complex64))
    S = torch.from_numpy(S.astype(np.complex64))
    N = torch.from_numpy(N.astype(np.complex64))
    frames, channels, bins = X.shape
    model = MaskBfEstimator(bins=bins, frames=frames, channels=channels, mode=args.mode, scaling=args.scaling, target_ch=target_ch, do_bn=args.do_bn)
    if args.gpu >= 0:
        model.cuda(args.gpu)
        X = X.cuda(args.gpu)
        S = S.cuda(args.gpu)
    # Setup optimizer
    optimizer = torch.optim.Adam(model.parameters(), lr=0.1)

    #max_epochs = args.max_epochs
    model.train()
    for epoch in range(args.max_epochs):
        #if epoch % 100 == 99:
        #    print(epoch)
        model.zero_grad()
        with Timer() as t:
            loss = model.calc_loss(X, S)
        t_fw += t.msecs

        with Timer() as t:
            #optimizer.zero_grad()
            loss.backward()
            optimizer.step()
        t_bw += t.msecs
        #print('Epoch:', epoch, '\tloss:', float(loss.cpu().detach().numpy()))
    
    model.eval()
    with Timer() as t:
        with torch.no_grad():  ## disable autograd
            Y = model.calc_scaled_bf(X, S)
    t_net += t.msecs

    if args.plot:
        masks = model.get_normalized_masks()
        #num_masks = masks.shape[1]
        #for i in range(num_masks):
        #    scatter_plot(masks[:,i], S[:,target_ch], N[:,target_ch], Y[:,0], X[:,target_ch], fig_no=i+1)
        #if num_masks == 2:
        #    scatter_plot(masks[:,0]+masks[:,1], S[:,target_ch], N[:,target_ch], Y[:,0], X[:,target_ch], fig_no=3)
        plot_specgrams(X[:,target_ch], masks, Y[:,0], S[:,target_ch], N[:,target_ch])
        scaling_mask = model.get_scaling_mask()
        if scaling_mask is not None:
            plot_specgrams(X[:,target_ch], scaling_mask, Y[:,0], S[:,target_ch], N[:,target_ch], fig_no=1)
        pl.show()

    Y = to_np(Y.squeeze(1))
    masks = model.get_normalized_masks()
    scaling_mask = model.get_scaling_mask()

    if scenario == 'simu' or args.track == 2:
        wsj_name = cur_line.split('/')[-1].split('_')[1]
        spk = cur_line.split('/')[-1].split('_')[0]
        env = cur_line.split('/')[-1].split('_')[-1]
    elif scenario == 'real':
        raise ValueError('Scenario \'real\' is not supported.')

    filename = os.path.join(
            args.output_dir,
            '{}05_{}_{}'.format(stage, env.lower(), scenario),
            '{}_{}_{}.wav'.format(spk, wsj_name, env.upper())
    )
    mask_filename = os.path.join(
            args.output_dir,
            '{}05_{}_{}'.format(stage, env.lower(), scenario),
            'masks_{}_{}_{}.npy'.format(spk, wsj_name, env.upper())
    )
    scaling_mask_filename = os.path.join(
            args.output_dir,
            '{}05_{}_{}'.format(stage, env.lower(), scenario),
            'scaling_mask_{}_{}_{}.npy'.format(spk, wsj_name, env.upper())
    )

    with Timer() as t:
        audiowrite(istft(Y)[int(context_samples):], filename, 16000, True, True)
        if masks is not None:
            np.save(mask_filename, to_np(masks))
        if scaling_mask is not None:
            np.save(scaling_mask_filename, to_np(scaling_mask))
    t_io += t.msecs

print('Finished')
print('Timings: I/O: {:.2f}s | FW: {:.2f}s | BW: {:.2f}s | Net: {:.2f}s'.format(
            t_io / 1000, t_fw / 1000, t_bw / 1000, t_net / 1000))

