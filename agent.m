%Make a function of the agent so another script can call up this function
%and it will take the history of the game rounds as an input and generate 
%an investment as an output.
function output = agent(current)
global combined_rounds
global pt
x = isempty(current);
%If the history is empty, proceed to randomly selecting a participant and
%use their first investment as the output.
if x == 1
    rd_1 = randsample(pt,1);
    output = combined_rounds(rd_1,1);
%If there is at least one round in the history, find the Euclidean distance
%between the past rounds and the rounds in the data. For the 2nd and 3rd 
%rounds, the vector 'current' will be shorter than the rest, so they will 
%only use their past 1 or 2 rounds. For rounds 4 on, only use the past 3 
%rounds.
else
    rd = length(current)+1;
    dis = [];
    startn = max(rd - 6, 1);
    endn = rd - 1;
    for n = startn:endn
        d = (current(n) - combined_rounds(:,n));
        dis = [dis, d];
    end
    dis = dis.^2;
    distance = sum(dis,2);
    distance = [pt,distance];
    %Then sort from least to greatest and take the closest 7 participants.
    distance_sorted = sortrows(distance,2);
    %If there is a tie AND some of the tied values are NOT part of the 7,
    %then randomly select however many values you need to equal 7.
    if distance_sorted(7,2) == distance_sorted(8,2);
        A = distance_sorted(:,2) == distance_sorted(7,2);
        A = sum(A);
        B = distance_sorted(:,2) < distance_sorted(7,2);
        B = sum(B);
        C = 7 - B;
        tie_sample = [distance_sorted(B+1:A+B,1)];
        random_tie = randsample(tie_sample,C);
        closest_seven = [distance_sorted([1:B],1);random_tie];
    else
        closest_seven = [distance_sorted([1:7],1)];
    end
    %Randomly choose one value from the sample of 7 closest participants
    %to be the current investment.
    sample = combined_rounds(closest_seven,rd);
    output = randsample(sample,1);
end
end