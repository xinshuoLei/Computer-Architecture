#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  if (cache_config.get_num_tag_bits() < 32) {
    uint32_t tag_bits = (1 << cache_config.get_num_tag_bits()) - 1;
    uint32_t shift_amout = cache_config.get_num_block_offset_bits() + cache_config.get_num_index_bits();
    uint32_t mask = tag_bits << shift_amout;
    return (mask & address) >> shift_amout;
  }
  return address;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  if (cache_config.get_num_index_bits() < 32) {
    uint32_t index_bits = (1 << cache_config.get_num_index_bits()) - 1;
    uint32_t shift_amout = cache_config.get_num_block_offset_bits();
    uint32_t mask = index_bits << shift_amout;
    return (mask & address) >> shift_amout;
  }
  return address;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  if (cache_config.get_num_block_offset_bits() < 32) {
    uint32_t offset_bits = (1 << cache_config.get_num_index_bits()) - 1;
    return (offset_bits & address);
  }
  return address;
}
