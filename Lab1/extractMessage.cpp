/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

unsigned char *extractMessage(const unsigned char *message_in, int length) {
    // length must be a multiple of 8
    assert((length % 8) == 0);

    // allocate an array for the output
    unsigned char *message_out = new unsigned char[length];
    for (int i = 0; i < length; i++) {
        message_out[i] = 0;
    }

    
    // TODO: write your code here 

    for (int x = 0; x < length; x+=8) {
        unsigned mask = 00000001;
        for (int z = 0; z < 8; z++) {
            unsigned char message = 0;
            for (int y = 7; y >= 0; y--) {
                unsigned char singleChar = message_in[y + x];
                unsigned single = singleChar & mask;
                single = single >> z;
                message += single << y;
            } 
            message_out[x + z] = message;
            mask = mask << 1;
        }
    }



    return message_out;
}
