/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	unsigned twoBit = (input & 0x55555555) + ((input & 0xAAAAAAAA) >> 1);
	unsigned fourBit = (twoBit& 0x33333333) + ((twoBit & 0xCCCCCCCC) >> 2);
	unsigned eightBit = (fourBit & 0x0f0f0f0f) + ((fourBit & 0xf0f0f0f0) >> 4);
	unsigned sixteenBit = (eightBit & 0x00ff00ff) + ((eightBit & 0xff00ff00) >> 8);
	unsigned result = (sixteenBit & 0x0000ffff) + ((sixteenBit & 0xffff0000) >> 16);
	return result;
}
