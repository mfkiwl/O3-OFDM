%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This file gives common paramters for IEEE 802.11n/ac protocol
% bw: bandwidth (1: 20 MHz; 2: 40 MHz)
% 
% Copyright (C) 2021.12.12  Shiyue He (hsy1995313@gmail.com)
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function IEEE80211ac_GlobalVariables(bw)

%% Frame structure
global N_FFT N_PILOT N_SYNC N_CP N_STF N_LTF N_DATA
switch bw
    case 1	% 20 MHz
        N_FFT       = 64;           % FFT size
        N_PILOT     = 4;        	% Number of pilots
        N_DATA      = 52;           % Number of data subcarriers
        N_SYNC      = 56;           % Number of STS and LTS
        N_CP        = 16;           % Cyclic prefix length
        N_STF       = 160;          % STF length; 16 * 10
        N_LTF       = 160;          % LTF length: 32 +2 * 64

    otherwise
        error('ERROR: bw must be [1]');
        
end
%% Subcarriers
global DC_INDEX PILOT_INDEX GUARD_INDEX DATA_INDEX SYNC_INDEX
DC_INDEX = 33;
PILOT_INDEX = DC_INDEX + [-21, -7, 7, 21];
GUARD_INDEX = DC_INDEX + [-32:-29, 29:31];
DATA_INDEX  = DC_INDEX + [-28:-22, -20:-8, -6:-1, 1:6, 8:20, 22:28];
SYNC_INDEX  = DC_INDEX + [-28:-1, 1:28];

%% Preambles and pilot
global STS LTS PILOTS CYCLIC_SHIFT P_HT_LTF
STS = sqrt(1/2)* ...
    [ 0 0 0 0  1+1j 0 0 0 -1-1j 0 0 0  1+1j 0 0 0 -1-1j 0 0 0 -1-1j 0 0 0  1+1j 0 0 0 ...	% subcarriers -28 : -1  
      0 0 0 -1-1j 0 0 0 -1-1j 0 0 0  1+1j 0 0 0  1+1j 0 0 0  1+1j 0 0 0  1+1j 0 0 0 0].';	% subcarriers 1 : 28
                    
LTS = sqrt(1/2)* ...
    [ 1  1  1  1 -1 -1  1  1 -1  1 -1  1  1  1  1  1  1 -1 -1  1  1 -1  1 -1  1  1  1  1 ...  subcarriers -28 : -1
      1 -1 -1  1  1 -1  1 -1  1 -1 -1 -1 -1 -1  1  1 -1 -1  1 -1  1 -1  1  1  1  1 -1 -1 ].';	% subcarriers 1 : 28


% Refer to Table 19-19 in IEEE 802.11ac standard
PILOTS{1} = [ 1,  1,  1, -1 ];  % 1 antenna;  transmit chain 1
PILOTS{2} = [ 1,  1, -1, -1     % 2 antennas; transmit chain 1
              1, -1, -1,  1 ];  % 2 antennas; transmit chain 2
PILOTS{3} = [ 1,  1, -1, -1;    % 3 antennas; transmit chain 1
              1, -1,  1, -1;    % 3 antennas; transmit chain 2
             -1,  1,  1, -1 ];  % 3 antennas; transmit chain 3
PILOTS{4} = [ 1,  1,  1, -1;    % 4 antennas; transmit chain 1
              1,  1, -1,  1;    % 4 antennas; transmit chain 2
              1, -1,  1,  1;    % 4 antennas; transmit chain 3
             -1,  1,  1,  1 ];  % 4 antennas; transmit chain 4

% Cyclic shift in samples (right shift)
% Refer to Table 19-10 in IEEE 802.11ac standard
CYCLIC_SHIFT{1} = 0;
CYCLIC_SHIFT{2} = [0, 8];
CYCLIC_SHIFT{3} = [0, 8, 4];
CYCLIC_SHIFT{4} = [0, 8, 4, 12];

% HT-LTF mapping matrix
P_HT_LTF = [ 1, -1,  1,  1;
             1,  1, -1,  1;
             1,  1,  1, -1;
            -1,  1,  1,  1 ];

% Spatial mapping: Direct mapping

%% MCS map in IEEE 802.11g standard
global MCS_MAT
MCS_MAT = [2, 2, 4, 4, 16, 16, 64, 64;
    2, 4, 2, 4, 2, 4, 3, 4];

%% Coding in IEEE 802.11g standard
global SCREAMBLE_POLYNOMIAL SCREAMBLE_INIT CONV_TRELLIS TAIL_LEN
SCREAMBLE_POLYNOMIAL    = [1 0 0 0 1 0 0 1];
SCREAMBLE_INIT          = [0 1 0 0 1 0 1];
CONV_TRELLIS            = poly2trellis(7, [133 171]);
TAIL_LEN                = 6;