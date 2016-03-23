/*
#University of Pittsburgh
#COE-147 Project Euler 150
#Instructor: Samuel J. Dickerson
#Teaching Assistants: Shivam Swami (shs173) and Bonan Yan (boy12)
#------------------------------------------------------------------------------------------------------------------------------------
#Submitted by: 	Tyler Protivnak, Zachary Adam, Signe Ruprecht
#
#Cited Source: 	The method of calculation was adapted from code posted by Nayuki from Github.				
#				We found this high level solution, learned how it worked and then refactored the code to use 
#				a one dimensional array instead of a two dimensional array, to make it easier to translate to assembly
#				Citing this source as per Dr. Dickerson's request if we used any ideas from online
*/

public final class HighLevelSolution {

    public static void main(String[] args) {
        System.out.println(new HighLevelSolution().run());  
    }

    private static final int ROWS = 1000; //Change this value to change number of rows

    public String run() {
        
        // Create pseudo-random triangle
        RandomNums rand = new RandomNums();
        int[] triangle = new int[ROWS * (ROWS + 1) / 2];
        for (int i = 0; i < triangle.length; i++) {//fill triangle with random numbers
            triangle[i] = rand.nextNum();
        }
		
        //Calculate cumulative sums for each row
        //strange indexing to allow for a one dimensional array 
        int[] rowSums = new int[triangle.length];
        for (int i = 0; i < ROWS; i++) {
            rowSums[i * (i + 1) / 2] = triangle[i * (i + 1) / 2];
            for (int j = (i * (i + 1) / 2) + 1; j <= (i * (i + 1) / 2) + i; j++) {
                rowSums[j] = rowSums[j - 1] + triangle[j];
            }
        }

        //Calculate minimum subtriangle sum for each apex position
        //strange indexing to allow the use of a one dimensional array
        long minSum = 0;
        for (int i = 0; i < ROWS-1; i++) {//loop through every row
            for (int j = (i * (i + 1) / 2); j <= (i * (i + 1) / 2) + i; j++) {//loop through every apex
                long currentSum = 0;
                int count = j;
                for (int k = i; k < ROWS; k++) {  //calculate triangle sum using rowSums
                    if (j == (i * (i + 1) / 2)) {//if this triangle is at an apex all the way on the left side of the row, we do not need to subtract anything
                        currentSum += rowSums[count];
                    } else {
                        currentSum += rowSums[count] - rowSums[count - (k - i + 1)];
                    }
                    minSum = Math.min(currentSum, minSum);
                    count += (k + 2);
                }
            }
        }
        return Long.toString(minSum);
    }

    private static final class RandomNums {

        private int state;

        public RandomNums() {
            state = 0;
        }

        public int nextNum() {
            state = (615949 * state + 797807) & ((1 << 20) - 1);
            return state - (1 << 19);
        }
    }
}