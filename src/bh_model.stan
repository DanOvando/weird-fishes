data{

int<lower = 0> n; // number of observations

vector[n] ssb; // vector of observed ssb

vector[n] r; // vector of recruits

real max_r;  // max observed recruitment


}
transformed data{

vector[n] log_r; // log recruitment

log_r = log(r);


}

parameters{

real<lower = 0.2, upper = 1> h; //steepness

real<lower = 0> log_alpha; // max recruitment

real log_beta; // unfished spawning biomass

real<lower = 0> sigma;


}
transformed parameters{

real beta = exp(log_beta);

real alpha = exp(log_alpha);

vector[n] rhat;

vector[n] log_rhat;

rhat = (0.8 * alpha * h * ssb) ./ (0.2 * beta * (1 - h) +(h - 0.2) * ssb);

// recruits_hat = (0.8 * r0 * h * spawners) ./ (0.2 * s0 * (1 - h) +(h - 0.2) * spawners);

// rhat = (0.8 * rec_pars[1] * h * ssb) ./ (0.2 * rec_pars[1] * (1 - h) +(h - 0.2) * ssb);

log_rhat = log(rhat);

}


model{

// log_r ~ normal(log_rhat - 0.5 * sigma^2, sigma);

log_r ~ normal(log_rhat, sigma);

sigma ~ cauchy(0,2.5);

log_alpha ~ normal(log(max_r), 4);

log_beta ~ normal(log(2*max(ssb)),2);

h ~ beta(6,2);


}

generated quantities{

  vector[n] pp_rhat;

  for (i in 1:n) {

   pp_rhat[i] = exp(normal_rng(log_rhat[i] - 0.5 * sigma^2, sigma));

  }

}
