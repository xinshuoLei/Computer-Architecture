#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t num_offset_bits = _cache_config.get_num_block_offset_bits();
  uint32_t num_index_bits = _cache_config.get_num_index_bits();
  uint32_t tag_bits = _tag << (num_offset_bits + num_index_bits);
  uint32_t index_bits = _index << num_offset_bits;
  return (tag_bits | index_bits);
}
