function movie_rate_array = predict_personalised(userid,movieid,rating_of_movies,rated_movies,non_rated_movies) 

Y_train = rating_of_movies;
User_train = userid;
Movie_train= movieid;

% Define Neural Network structure
NNStructDefinition.nbLayers                     = 3;

NNStructDefinition.layers                       = [];

NNStructDefinition.layers{1}.type               = 'input';
NNStructDefinition.layers{1}.nbNeurons          = 1;

NNStructDefinition.layers{2}.type               = 'hidden';
NNStructDefinition.layers{2}.activation_type    = 'sigmoid';
NNStructDefinition.layers{2}.nbNeurons          = 20;


NNStructDefinition.layers{3}.type               = 'output';
NNStructDefinition.layers{3}.activation_type    = 'sigmoid';
NNStructDefinition.layers{3}.nbNeurons          = 5;

NNStructDefinition.learning_rate                = 0.001;


[ W_u,W_m, B_u,B_m ] = NN_train( NNStructDefinition, User_train, Movie_train, Y_train,1 );


movie_rate_array = NN_predict(NNStructDefinition,userid(end),non_rated_movies,W_u,W_m,B_u,B_m);
end
