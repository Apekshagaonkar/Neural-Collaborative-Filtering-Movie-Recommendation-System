clc;
clear all;
close all;

dataTable=loadDataset();
[idx,movieList] = loadMovieList();

userid=dataTable.userid;
movieid=dataTable.movieid;
rating_of_movies=dataTable.rating;
non_rated_movies=idx;


%  Initialize my ratings
my_ratings = zeros(5500, 1);

% Check the file movie_idx.txt for id of each movie in our dataset

my_ratings(5) = 4;
my_ratings(110) = 2;
my_ratings(7) = 3;
my_ratings(12)= 5;
my_ratings(54) = 4;
my_ratings(64)= 5;
my_ratings(66)= 3;
my_ratings(69) = 5;
my_ratings(183) = 4;
my_ratings(226) = 5;
my_ratings(355)= 5;

rated_movies=[];

fprintf('\nNew user ratings:\n');
for i = 1:length(my_ratings)
    if my_ratings(i) > 0 
        fprintf('Rated %d for %s\n', my_ratings(i),movieList{i});
        rated_movies=[rated_movies i];
        userid=[userid; 11];
        rating_of_movies=[rating_of_movies;my_ratings(i)];    
    end
end
movieid=[movieid ; rated_movies'];

%disp(rated_movies);
fprintf('\nProgram paused. Press enter to continue.\n');
pause;


    
%TO REMOVE ELEMENTS THAT ARE RATED FROM THE MOVIES
k=1;
while(k<=length(rated_movies))
    for i=1:length(non_rated_movies)
        if(non_rated_movies(i)==rated_movies(k))
            non_rated_movies(i)=1683;
        end
    end
    k=k+1;
end


movie_rate_array=predict_personalised(userid,movieid,rating_of_movies,rated_movies,non_rated_movies);  

movie_rate_array1=movie_rate_array;
k=0;
p=0;
y=[];

while(j<=10)
k=max(movie_rate_array1)
for i=1:length(movie_rate_array1)
if(movie_rate_array1(i)==k)
         p=i;
         movie_rate_array1(i)=0;  
         y=[y p];
         j=j+1;
         
end
end
end

y = unique(y);
disp('y');
movie_id_array= y;

fprintf('\n The recommended movies are : \n');
for i = 1:5
        k=movie_id_array(i);
        fprintf('Movie name : %s\n',movieList{k});
end