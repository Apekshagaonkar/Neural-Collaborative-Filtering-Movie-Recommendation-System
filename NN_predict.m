function [Y_pred] = NN_predict( NNStructDefinition,userid,non_rated_movies,W_u,W_m,B_u,B_m )

	
    Y_pred = zeros(1,1683);
    [H_u, ~] = NN_feedforward(NNStructDefinition, userid, W_u, B_u);
    for i=1:length(non_rated_movies)
        [H_m, ~] = NN_feedforward(NNStructDefinition, non_rated_movies(i), W_m, B_m);   
        H=H_u{end}'*H_m{end};
        H=sigmoid(H)*5;
        movie=non_rated_movies(i);
        Y_pred(movie) =round(H);
        
    end

end

function [ y ] = sigmoid(x)

    y = 1 ./ (1 + exp(-x));

end


