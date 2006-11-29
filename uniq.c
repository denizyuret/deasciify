#include <glib.h>
#include "foreach.h"

int main() {
  GStringChunk *strings = g_string_chunk_new(1024);
  GHashTable *strtable = g_hash_table_new(g_str_hash, g_str_equal);
  foreach_line(buf, NULL) {
    if (!g_hash_table_lookup(strtable, buf)) {
      gchar *s = g_string_chunk_insert(strings, buf);
      g_hash_table_insert(strtable, s, s);
      fputs(s, stdout);
    }
  }
}
