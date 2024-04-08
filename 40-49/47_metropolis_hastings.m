% METROPOLIS HASTINGS ALGORITHM

% taken from here: https://compcogsci-3016.djnavarro.net/technote_metropolishastings.pdf
% need to make full adjustments to everything
pkg load statistics

function [X,acc] = MHsimple

	% parameters
	burnin = 0; % number of burn-in iterations
	lag = 1; % iterations between successive samples
	nsamp = 1000; % number of samples to draw
	sig = 50; % standard deviation of Gaussian proposal
	x = -1; % start point
	% storage

	X = zeros(nsamp,1); % samples drawn from the Markov chain
	acc = [0 0]; % vector to track the acceptance rate

	% MH routine
	for i = 1:burnin
		[x,a] = MHstep(x,sig); % iterate chain one time step
		acc = acc + [a 1]; % track accept-reject status
	endfor

	for i = 1:nsamp
		for j = 1:lag
			[x,a] = MHstep(x,sig); % iterate chain one time step
			acc = acc + [a 1]; % track accept-reject status
		endfor
		X(i) = x; % store the i-th sample
	endfor


endfunction

function [x1,a] = MHstep(x0,sig)

	xp = normrnd(x0,sig); % generate candidate from Gaussian
	accprob = targetdist(xp) / targetdist(x0); % acceptance probability
	u = rand; % uniform random number

	if u <= accprob % if accepted
		x1 = xp; % new point is the candidate
		a = 1; % note the acceptance
	else % if rejected
		x1 = x0; % new point is the same as the old one
		a = 0; % note the rejection
	endif
endfunction

function probX = targetdist(x)
	% disp('Hello, World!')
	probX = exp(-x.^2) .* (2 + sin(x*5) + sin(x*2));

endfunction

MHsimple()

