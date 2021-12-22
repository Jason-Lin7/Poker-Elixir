defmodule Poker do
    #For this assignment we made Ace High Card
    def deal(array) do
        player1score=0
        player2score=0
        player1= [Enum.at(array,0),Enum.at(array,2),Enum.at(array,4),Enum.at(array,6),Enum.at(array,8)] #Gives player1 the even cards
        player1=Enum.sort(player1) #Sorts Player1 Hand
        player2= [Enum.at(array,1),Enum.at(array,3),Enum.at(array,5),Enum.at(array,7),Enum.at(array,9)]#Gives player2 the odd cards
        player2=Enum.sort(player2) #Sorts Player2 Hand
        remainder1=Enum.map(player1, &(rem(&1,13))) #Calculates the remainder for hand 1
        remainder2=Enum.map(player2, &(rem(&1,13))) #Calculates the ramainder for hand 2

        add13KingAce? = fn #This anonymous function adds 13 when the value is a king or ace so it lets Ace or King become high card
            x when x==0 or x==1 -> x+13 #This checks if x is 0 or 1 and adds 13
            x-> x
        end
        remainder1=Enum.map(remainder1,add13KingAce?) #This adds 13 to Ace and King values
        remainder2=Enum.map(remainder2,add13KingAce?) #Applies same concept above to remainder2
        remainder1=Enum.sort(remainder1) #sorts the hand in numerical order
        remainder2=Enum.sort(remainder2) #Applies same concept to remainder2

        player1score=player1score+pair(remainder1)  #Adds score if pair
        player1score=player1score+doublePair(remainder1) #Adds score if doublepair
        player1score=player1score+threeOfAKind(remainder1) #Adds score if three of a kind
        player1score=player1score+straight(remainder1) #Adds score if straight
        player1score=player1score+flush(player1) #Adds score if flush
        player1score=player1score+fullHouse(remainder1) #Adds score if full house
        player1score=player1score+fourOfAKind(remainder1) #Adds score if FourOfAKind
        #straightflush will have score of flush and straight added together
        player1score=player1score+royalflush(player1) #Adds score if Royal Flush

        #Apply same concept to player2
        player2score=player2score+pair(remainder2)
        player2score=player2score+doublePair(remainder2)
        player2score=player2score+threeOfAKind(remainder2)
        player2score=player2score+straight(remainder2)
        player2score=player2score+flush(player2)
        player2score=player2score+fullHouse(remainder2)
        player2score=player2score+fourOfAKind(remainder2)
        player2score=player2score+royalflush(player2)
        winner(player1score,player2score,player1,player2,remainder1,remainder2)

        sub13Ace? = fn #Makes Ace a 1 again for output
            x when x==14 -> x-13 #This checks if x is 0 or 1 and adds 13
            x-> x
        end
        remainder1=Enum.map(remainder1,sub13Ace?) #This adds 13 to Ace and King values
        remainder2=Enum.map(remainder2,sub13Ace?) #Applies same concept above to remainder2
        remainder1=Enum.sort(remainder1) #sorts the hand in numerical order
        remainder2=Enum.sort(remainder2) #Applies same concept to remainder2

    end

    def pair(remainder) do
        pair1=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,0)) == x end))   #Checks for pairs with first index
        pair2=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,pair1)) == x end)) #Checks for if theres a pair with the 2nd value in array
        pair3=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,pair1+pair2)) == x end)) #Checks for if theres a pair with the 3rd value in array
        pair4=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,pair1+pair2+pair3)) == x end)) #Checks for if theres a pair with the 4th value in array
        if pair1==2 || pair2==2 || pair3==2 || pair4==2 do
            1 #If there is a pair, 1 will be added to the player score
        else
            0 #If not, there will be nothing added
        end
    end

    def doublePair(remainder) do
        pair1=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,1)) == x end))   #Checks for pairs with first index
        pair2=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,pair1+1)) == x end)) #Checks for if theres a pair in the second set of value
        pair3=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,pair1+pair2+1)) == x end)) #Checks if there are any pairs with the third value in the array
        pair4=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,pair1+pair2+pair3+1)) == x end)) #Checks if there are any pairs with the fourth value in the array
        if pair1==2 && pair2==2 || pair1==2 && pair3==2 || pair1==2 && pair4==2 || pair2==2 && pair3==2 || pair2==2 && pair4==2 || pair3==2 && pair4==4 do #Checks if there are 2 pairs
            1 #Since we are adding 1 for one pair, we add another 1 for two pairs
        else
            0 #Adds zero, if there are no double pairs
        end
    end

    def threeOfAKind(remainder) do
        pair1=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,1)) == x end))   #Checks for triple with first index
        pair2=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,pair1+1)) == x end)) #Checks for if theres a triple in the second set of value
        pair3=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,pair1+pair2+1)) == x end)) #Checks if there are any triples in the third set of values
        if pair1==3 || pair2==3 || pair3==3 do
            3 #Add 3 if there is a three of a kind
        else
            0 #Adds zero, if there are no threeOfAKinds
        end
    end

    def straight(remainder) do #Checks for a straight
        size=length(Enum.uniq(remainder)) #Checks for the size of all unique values in list
        first=Enum.at(remainder,0) #Finds the first value in the array
        last=Enum.at(remainder,4) #Finds the last value in the array
        if size==5 && (first+4)==last do #If the array size is 5 and the first value +4 =5, then we know that it is a straight
            4
        else
            0
        end
    end

    def flush(player) do
        suitClubs=length(Enum.filter(player, fn x -> x <= 13 end)) #checks for amount of cards that have clubs
        suitDiamonds=length(Enum.filter(player, fn x -> (x <= 26 && x >13) end)) #checks for amount of cards that have diamonds
        suitHearts=length(Enum.filter(player, fn x -> (x <= 39 && x >26) end)) #checks for amount of cards that have hearts
        suitSpades=length(Enum.filter(player, fn x -> (x <= 52 && x >39) end)) #checks for amount of cards that have spades
        if suitClubs==5 || suitDiamonds==5 || suitHearts==5 || suitSpades==5 do #checks if there are 5 of the same suit, if it's true, then the result will be 5
            5
        else
            0
        end
    end

    def fullHouse(remainder) do
        pair1=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,1)) == x end))   #Checks for triple or double with first index
        pair2=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,pair1+1)) == x end)) #Checks for if theres a triple or double in the second set of value
        if pair1==3 && pair2==2 || pair1==2 && pair2==3 do  #Checks for full house
            2
        else
            0
        end
    end

    def fourOfAKind(remainder) do
        pair1=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,1)) == x end))   #Checks for four of a kind with first index
        pair2=length(Enum.filter(remainder, fn x -> (Enum.at(remainder,pair1+1)) == x end)) #Checks for four of a kind in the second set of value
        if pair1==4 || pair2==4 do  #Checks if theres 4 of a kind
            7
        else
            0
        end
    end

    def royalflush(player) do
        if (Enum.member?(player, 1) && Enum.member?(player,10) && Enum.member?(player,11) && Enum.member?(player,12) && Enum.member?(player,13)) ||  #Checks royal flush for clubs
            (Enum.member?(player, 14) && Enum.member?(player,23) && Enum.member?(player,24) && Enum.member?(player,25) && Enum.member?(player,26)) ||  #Checks royal flush for Diamonds
            (Enum.member?(player, 27) && Enum.member?(player,36) && Enum.member?(player,37) && Enum.member?(player,38) && Enum.member?(player,39)) ||   #Checks royal flush for Hearts
            (Enum.member?(player, 40) && Enum.member?(player,49) && Enum.member?(player,50) && Enum.member?(player,51) && Enum.member?(player,52)) do #Checks royal flush for Spades
            1
        else
            0
        end
    end

    def winner(score1,score2,player1,player2,remainder1,remainder2) do
        winner=nil
        cond do 
            score1==0 && score2==0 ->
                winner=flushTie(player1,player2,remainder1,remainder2)
            score1==1 && score2==1 ->
                winner=pairTie(player1,player2,remainder1,remainder2)
            score1==2 && score2==2 ->
                winner=doublePairTie(player1,player2,remainder1,remainder2)
            score1==3 && score2==3 ->
                winner=threeOfAKindTie(remainder1,remainder2)
            score1==4 && score2==4 ->
                winner=straightTie(player1,player2,remainder1,remainder2)
            score1==5 && score2==5 ->
                winner=flushTie(player1,player2,remainder1,remainder2)
            score1==6 && score2==6 ->
                winner=fullHouseTie(remainder1,remainder2)
            score1==7 && score2==7 ->
                winner=fourOfAKindTie(remainder1,remainder2)
            score1==9 && score2==9 ->
                winner=straightFlushTie(remainder1,remainder2)
            score1==10 && score2==10 ->
                winner=royalFlushTie(player1,player2)
            score1>score2 ->
                winner="Player1"
            score2>score1 ->
                winner="Player2"
        end    
    end

    def pairTie(player1,player2,remainder1,remainder2) do
        pair1=length(Enum.filter(remainder1, fn x -> (Enum.at(remainder1,0)) == x end))   
        pair2=length(Enum.filter(remainder1, fn x -> (Enum.at(remainder1,pair1)) == x end)) 
        pair3=length(Enum.filter(remainder1, fn x -> (Enum.at(remainder1,pair1+pair2)) == x end)) 
        pair4=length(Enum.filter(remainder1, fn x -> (Enum.at(remainder1,pair1+pair2+pair3)) == x end)) 
        
        pair21=length(Enum.filter(remainder2, fn x -> (Enum.at(remainder2,0)) == x end))   
        pair22=length(Enum.filter(remainder2, fn x -> (Enum.at(remainder2,pair21)) == x end)) 
        pair23=length(Enum.filter(remainder2, fn x -> (Enum.at(remainder2,pair21+pair22)) == x end)) 
        pair24=length(Enum.filter(remainder2, fn x -> (Enum.at(remainder2,pair21+pair22+pair23)) == x end))
        number= cond do
            pair1==2 ->
                number=pair1
            pair2==2 ->
                number=pair1+1
            pair3==2 ->
                number=pair1+pair2+1
            pair4==2 ->
                number=pair1+pair2+pair3+1
        end
        number=number-1
        number2= cond do
            pair21==2 ->
                number=pair21
            pair22==2 ->
                number=pair21+1
            pair23==2 ->
                number=pair21+pair22+1
            pair24==2 ->
                number=pair21+pair22+pair23+1
        end
        number2=number2-1

        cond do
            Enum.at(remainder1,number)>Enum.at(remainder2,number2) ->
                winner="Player1"
            Enum.at(remainder2,number2)>Enum.at(remainder1,number) ->
                winner="Player2"
            Enum.at(remainder1,4)>Enum.at(remainder2,4) ->
                winner="Player1"
            Enum.at(remainder2,4)>Enum.at(remainder1,4) ->
                winner="Player2"
            Enum.at(remainder1,3)>Enum.at(remainder2,3) ->
                winner="Player1"
            Enum.at(remainder2,3)>Enum.at(remainder1,3) ->
                winner="Player2"
            Enum.at(remainder1,2)>Enum.at(remainder2,2) ->
                winner="Player1"
            Enum.at(remainder2,2)>Enum.at(remainder1,2) ->
                winner="Player2"
            Enum.at(remainder1,1)>Enum.at(remainder2,1) ->
                winner="Player1"
            Enum.at(remainder2,1)>Enum.at(remainder1,1) ->
                winner="Player2"
            Enum.at(remainder1,0)>Enum.at(remainder2,0) ->
                winner="Player1"
            Enum.at(remainder2,0)>Enum.at(remainder1,0) ->
                winner="Player2"
            
            Enum.at(player1,4)>Enum.at(player2,4) ->
                winner="Player1"
            Enum.at(player2,4)>Enum.at(player1,4) ->
                winner="Player2"
            Enum.at(player1,3)>Enum.at(player2,3) ->
                winner="Player1"
            Enum.at(player2,3)>Enum.at(player1,3) ->
                winner="Player2"
            Enum.at(player1,2)>Enum.at(player2,2) ->
                winner="Player1"
            Enum.at(player2,2)>Enum.at(player1,2) ->
                winner="Player2"
            Enum.at(player1,1)>Enum.at(player2,1) ->
                winner="Player1"
            Enum.at(player2,1)>Enum.at(player1,1) ->
                winner="Player2"
            Enum.at(player1,0)>Enum.at(player2,0) ->
                winner="Player1"
            Enum.at(player2,0)>Enum.at(player1,0) ->
                winner="Player2"
        end
    end

    def doublePairTie(player1,player2,remainder1,remainder2) do
        first=Enum.at(Enum.uniq(remainder1),0)
        second=Enum.at(Enum.uniq(remainder1),1)
        third=Enum.at(Enum.uniq(remainder1),2)
        first2=Enum.at(Enum.uniq(remainder2),0)
        second2=Enum.at(Enum.uniq(remainder2),1)
        third2=Enum.at(Enum.uniq(remainder2),2)
        cond do 
            Enum.at(remainder1,3)>Enum.at(remainder2,3) ->
                winner="Player1"
            Enum.at(remainder2,3)>Enum.at(remainder1,3) ->
                winner="Player2"
            Enum.at(remainder1,1)>Enum.at(remainder2,1) ->
                winner="Player1"
            Enum.at(remainder2,1)>Enum.at(remainder1,1) ->
                winner="Player2"
            third>third2 ->
                winner="Player1"
            third2>third ->
                winner="Player2"
            second>second2 ->
                winner="Player1"
            second2>second ->
                winner="Player2"
            first>first2 ->
                winner="Player1"
            first2>first ->
                winner="Player2"
            Enum.at(player1,4)>Enum.at(player2,4) ->
                winner="Player1"
            Enum.at(player2,4)>Enum.at(player1,4) ->
                winner="Player2"
            Enum.at(player1,3)>Enum.at(player2,3) ->
                winner="Player1"
            Enum.at(player2,3)>Enum.at(player1,3) ->
                winner="Player2"
            Enum.at(player1,2)>Enum.at(player2,2) ->
                winner="Player1"
            Enum.at(player2,2)>Enum.at(player1,2) ->
                winner="Player2"
            Enum.at(player1,1)>Enum.at(player2,1) ->
                winner="Player1"
            Enum.at(player2,1)>Enum.at(player1,1) ->
                winner="Player2"
            Enum.at(player1,0)>Enum.at(player2,0) ->
                winner="Player1"
            Enum.at(player2,0)>Enum.at(player1,0) ->
                winner="Player2"
        end
    end

    def threeOfAKindTie(remainder1,remainder2) do
        cond do
            Enum.at(remainder1,2)>Enum.at(remainder2,2) ->
                winner="Player1"
            Enum.at(remainder2,2)>Enum.at(remainder1,2) ->
                winner="Player2"
        end
    end
    
    def straightTie(player1,player2,remainder1,remainder2) do
        cond do
            Enum.at(remainder1,4)>Enum.at(remainder2,4) ->
                winner="Player1"
            Enum.at(remainder2,4)>Enum.at(remainder1,4) ->
                winner="Player2"
            Enum.at(player1,3)>Enum.at(player2,3) ->
                winner="Player1"
            Enum.at(player2,3)>Enum.at(player1,3) ->
                winner="Player2"
            Enum.at(player1,2)>Enum.at(player2,2) ->
                winner="Player1"
            Enum.at(player2,2)>Enum.at(player1,2) ->
                winner="Player2"
            Enum.at(player1,1)>Enum.at(player2,1) ->
                winner="Player1"
            Enum.at(player2,1)>Enum.at(player1,1) ->
                winner="Player2"
            Enum.at(player1,0)>Enum.at(player2,0) ->
                winner="Player1"
            Enum.at(player2,0)>Enum.at(player1,0) ->
                winner="Player2"
        end
    end

    def flushTie(player1,player2,remainder1,remainder2) do
        cond do 
            Enum.at(remainder1,4)>Enum.at(remainder2,4) ->
                winner="Player1"
            Enum.at(remainder2,4)>Enum.at(remainder1,4) ->
                winner="Player2"
            Enum.at(remainder1,3)>Enum.at(remainder2,3) ->
                winner="Player1"
            Enum.at(remainder2,3)>Enum.at(remainder1,3) ->
                winner="Player2"
            Enum.at(remainder1,2)>Enum.at(remainder2,2) ->
                winner="Player1"
            Enum.at(remainder2,2)>Enum.at(remainder1,2) ->
                winner="Player2"
            Enum.at(remainder1,1)>Enum.at(remainder2,1) ->
                winner="Player1"
            Enum.at(remainder2,1)>Enum.at(remainder1,1) ->
                winner="Player2"
            Enum.at(remainder1,0)>Enum.at(remainder2,0) ->
                winner="Player1"
            Enum.at(remainder2,0)>Enum.at(remainder1,0) ->
                winner="Player2"
            
            Enum.at(player1,4)>Enum.at(player2,4) ->
                winner="Player1"
            Enum.at(player2,4)>Enum.at(player1,4) ->
                winner="Player2"
            Enum.at(player1,3)>Enum.at(player2,3) ->
                winner="Player1"
            Enum.at(player2,3)>Enum.at(player1,3) ->
                winner="Player2"
            Enum.at(player1,2)>Enum.at(player2,2) ->
                winner="Player1"
            Enum.at(player2,2)>Enum.at(player1,2) ->
                winner="Player2"
            Enum.at(player1,1)>Enum.at(player2,1) ->
                winner="Player1"
            Enum.at(player2,1)>Enum.at(player1,1) ->
                winner="Player2"
            Enum.at(player1,0)>Enum.at(player2,0) ->
                winner="Player1"
            Enum.at(player2,0)>Enum.at(player1,0) ->
                winner="Player2"
        end
    end

    def fullHouseTie(remainder1,remainder2) do
        if Enum.at(remainder1,2)>Enum.at(remainder2,2) do
            winner="Player1"
        else
            winner="Player2"
        end
    end

    def fourOfAKindTie(remainder1,remainder2) do
        if Enum.at(remainder1,2)>Enum.at(remainder2,2) do
            winner="Player1"
        else
            winner="Player2"
        end
    end

    def straightFlushTie(player1,player2) do
        if Enum.at(player1,4)>Enum.at(player2,4) do
            winner="Player1"
        else
            winner="Player2"
        end
    end

    def royalFlushTie(player1,player2) do
        if Enum.at(player1,0)>Enum.at(player2,0) do
            winner="Player1"
        else
            winner="Player2"
        end
    end
end

IO.inspect Poker.deal([1,2,3,4,5,6,7,8,9,10])
