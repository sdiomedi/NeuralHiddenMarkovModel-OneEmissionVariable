function [ guessA , guessb ,loglikes] = hmm_training( seqs,pi,guessA,guessb,info )
%% Train Hidden Markov Models (HMMs) using the Baum-Welch algorithm.
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Inputs:
% - seqs: Emission sequences for training.
% - pi: Initial state probabilities.
% - guessA: Initial transition matrix.
% - guessb: Initial emission matrix.
% - info: Struct containing information about the HMM and training parameters.

%% Outputs:
% - guessA: Trained transition matrix.
% - guessb: Trained emission matrix.
% - loglikes: Log-likelihood values over iterations.

trtol=info.tol;
etol=info.tol;
tol=info.tol;

A = zeros(size(guessA));
b = zeros(size(guessb));

pseudob=b;
pseudoA=A;

converged = false;
loglike = 1; 
loglikes = zeros(1,info.maxiter);

for iteration = 1:info.maxiter
    oldloglike = loglike;
    loglike = 0;
    oldguessA = guessA;
    oldguessb = guessb;

    for count = 1:(info.number_emission_sequence_for_trial*(info.cross_validation-1))
       
        seq = seqs(count,:);
        
        [ alpha , logprob , scale] = fwd_nolog(seq,pi,guessA,guessb,info.number_of_states);
        [ beta ] = bwd_nolog(seq,guessA,guessb,scale,info.number_of_states);
        loglike = loglike + logprob;
        logalpha=log(alpha);
        logbeta=log(beta);
        logguessA=log(guessA);
        logguessb=log(guessb);

        seq = [0 seq];

        for k = 1:info.number_of_states
            for l = 1:info.number_of_states
                for i = 1:info.number_of_bin_for_trial
                    A(k,l) = A(k,l) + exp( logalpha(k,i) + logguessA(k,l) + logguessb(l,seq(i+1)) + logbeta(l,i+1))./scale(i+1);
                end
            end
        end
        for k = 1:info.number_of_states
            for i = 1:(info.number_of_neurons+1)
                pos = find(seq == i);
                b(k,i) = b(k,i) + sum(exp(logalpha(k,pos)+logbeta(k,pos)));
            end
        end

    end
    norm_b = sum(b,2);
    norm_A = sum(A,2);
    % normalizzation
    guessb = b./(repmat(norm_b,1,info.number_of_neurons+1));
    guessA  = A./(repmat(norm_A,1,info.number_of_states));
    % clean zeros
    if any(norm_A == 0)
        noTransitionRows = find(norm_A == 0);
        guessA(noTransitionRows,:) = 0;
        guessA(sub2ind(size(guessA),noTransitionRows,noTransitionRows)) = 1;
    end
    % clean Nans
    guessA(isnan(guessA)) = 0;
    guessb(isnan(guessb)) = 0;

    % convergence criteria
    loglikes(iteration) = loglike;
    if (abs(loglike-oldloglike)/(1+abs(oldloglike))) < tol
        if norm(guessA - oldguessA,inf)/info.number_of_states < trtol
            if norm(guessb - oldguessb,inf)/(info.number_of_neurons+1) < etol
                
                     fprintf('%s\n',getString(message('stats:hmmtrain:ConvergedAfterIterations',iteration)))
                
                converged = true;
                break
            end
        end
    end
    b =  pseudob;
    A = pseudoA;
end
if ~converged
    warning(message('stats:hmmtrain:NoConvergence', num2str( tol ), info.maxiter));
end
loglikes(loglikes ==0) = [];
end