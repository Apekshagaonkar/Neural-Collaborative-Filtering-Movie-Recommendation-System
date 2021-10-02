function [ W, B ] = NN_backpropagate( NNStructDefinition, X, Y, W, B, H,H_x ,Z, learning_rate )


    Deltas = cell(1, NNStructDefinition.nbLayers-1);

    % First, compute all deltas
    for i=NNStructDefinition.nbLayers:-1:2
        
        if i == NNStructDefinition.nbLayers
            D = (Y - H) .* feval(strcat(NNStructDefinition.layers{i}.activation_type, '_derivative'), Z{i-1});
        else
            D = (transpose(W{(i-1)+1}) * Deltas{(i-1)+1}) .* feval(strcat(NNStructDefinition.layers{i}.activation_type, '_derivative'), Z{i-1});
        end
        
        Deltas{i-1} = D;
        
    end
    
    % Then, compute weights updates
    for i=NNStructDefinition.nbLayers:-1:2
        
        if i == 2
            h = X;
        else
            h = H_x{(i-1)-1};
        end
        
        W{i-1} = W{i-1} + learning_rate * Deltas{i-1} * transpose(h);
        B{i-1} = B{i-1} + learning_rate * Deltas{i-1};
        
    end

end

function [ y ] = sigmoid(x)

    y = 1 ./ (1 + exp(-(x)));

end

function [ y ] = tangenth(x)

    
    y = tanh(x);

end


function [ y ] = sigmoid_derivative(x)

    y = sigmoid(x) .* (1 - sigmoid(x));

end

function [ y ] = tangenth_derivative(x)

    y = zeros(size(x, 1), size(x, 2));
    
    for i=1:size(x, 1)
        for j=1:size(x, 2)
            y(i, j) = 1 - tanh(x(i, j))^2;
        end
    end

end

function [ y ] = relu_derivative(x)

    y = zeros(size(x, 1), size(x, 2));
    
    for i=1:size(x, 1)
        for j=1:size(x, 2)
            if x(i, j) <= 0
                y(i, j) = 0;
            else
                y(i, j) = 1;
            end
        end
    end

end