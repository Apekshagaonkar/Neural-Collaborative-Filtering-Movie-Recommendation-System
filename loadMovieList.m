function [idx,movieList] = loadMovieList()

fid = fopen('movie_ids.txt');


n = 1683;  % Total number of movies 

movieList = cell(n, 1);
idx=[];
for i = 1:n
    % Read line
    line = fgets(fid);
    
    [idxx, movieName] = strtok(line, ' ');
    % Actual Word
    movieList{i} = strtrim(movieName);
    idx=[idx,str2num(idxx)];
end
idx=idx.';
fclose(fid);

end
