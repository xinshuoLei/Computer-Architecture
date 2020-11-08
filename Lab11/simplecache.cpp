#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  if (index >= 0 && (size_t) index < _cache.size()) {
    for (size_t i = 0; i < _cache[index].size(); i++) {
      if (_cache[index][i].tag() == tag && _cache[index][i].valid()) {
          if(block_offset >= 0 && block_offset < 4) {
            return _cache[index][i].get_byte(block_offset);
          }         
      }
    }
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign (see "C++ Rule of Three")
  if (index >= 0 && (size_t) index < _cache.size()) {
    for (size_t i = 0; i < _cache[index].size(); i++) {
      if (!_cache[index][i].valid()) {
        _cache[index][i].replace(tag, data);
        return;
      }
    }
    _cache[index][0].replace(tag, data);
  }
}
