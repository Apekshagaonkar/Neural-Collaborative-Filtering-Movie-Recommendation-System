function [W_u,W_m,B_u,B_m] = NN_train(  NNStructDefinition, User_train,Movie_train, Y_train, max_iteration_number )

	
    nbFoundInputLayer  = 0;
    nbFoundOutputLayer = 0;

    W = cell(1, NNStructDefinition.nbLayers-1);
    B = cell(1, NNStructDefinition.nbLayers-1);
    
    if strcmp(NNStructDefinition.layers{1}.type, 'input') ~= 1
       error('Error : The neural network must begin by an input layer.'); 
    end
    
    if strcmp(NNStructDefinition.layers{end}.type, 'output') ~= 1
       error('Error : The neural network must end by an output layer.'); 
    end
    
    nbFoundInputLayer   = 1;

    for i=2:NNStructDefinition.nbLayers
        
        boCreateW = 0;
        
        LayerDef = NNStructDefinition.layers{i};
        
        if strcmp(LayerDef.type, 'input') == 1
            nbFoundInputLayer  = nbFoundInputLayer + 1;
        elseif strcmp(LayerDef.type, 'output') == 1
            nbFoundOutputLayer = nbFoundOutputLayer + 1;
            boCreateW = 1;
        else
            boCreateW = 1;
        end
        
        if boCreateW == 1
            w = zeros(LayerDef.nbNeurons, NNStructDefinition.layers{i-1}.nbNeurons);
            b = zeros(LayerDef.nbNeurons, 1);
            
            W{i-1} = w;
            B{i-1} = b; 
        end
        
    end
    
    if nbFoundInputLayer == 0
        error('Error : No input layer found.'); 
    elseif nbFoundInputLayer > 1
        error('Error : More than one input layer found.'); 
    elseif nbFoundOutputLayer == 0
        error('Error : No output layer found.'); 
    elseif nbFoundOutputLayer > 1
        error('Error : More than one output layer found.'); 
    end
    
    
    %%%% Initialize the weights and biases
    [W_u, B_u] = Initialize_Weights_And_Biases(W, B);
    [W_m, B_m] = Initialize_Weights_And_Biases(W, B);
    
    %%%% Train neural network
    it = 0;
    
    while it <= max_iteration_number
        
        nbErrors = 0;
        disp(size(User_train));
        for i=1:size(User_train, 1)

            [H_u, Z_u] = NN_feedforward(NNStructDefinition, transpose(User_train(i, :)), W_u, B_u);
            [H_m, Z_m] = NN_feedforward(NNStructDefinition, transpose(Movie_train(i, :)), W_m, B_m);
            H=H_u{end}'*H_m{end};% We obtain the user feature interaction matrix
            H=sigmoid(H)*5;%h=5
            H=round(H);
            if isequal(H,Y_train(i)) == 0
                nbErrors = nbErrors + 1;
                [W_u, B_u] = NN_backpropagate(NNStructDefinition, transpose(User_train(i, :)),  transpose(Y_train(i, :)), W_u, B_u, H, H_u,Z_u, NNStructDefinition.learning_rate);
                [W_m,B_m]  = NN_backpropagate(NNStructDefinition, transpose(Movie_train(i, :)), transpose(Y_train(i, :)), W_m, B_m, H, H_m,Z_m, NNStructDefinition.learning_rate);
            end
        end
        
        if nbErrors == 0
            break;
        end
        
        it = it + 1;
        disp('Error');
        disp(nbErrors)
    end
    
end

function [ W, B ] = Initialize_Weights_And_Biases( W, B )

    for i=1:length(W)
        W{i} = -0.001 + (rand(size(W{i}, 1), size(W{i}, 2)) * (0.002));
        B{i} = -0.001 + (rand(size(B{i}, 1), size(B{i}, 2)) * (0.002));
    end

end
  

function [ y ] = sigmoid(x)

    y = 1 ./ (1 + exp(-x));

end

