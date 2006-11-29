#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <glib.h>
#include "foreach.h"

static unsigned *ht;
GStringChunk *strings;
GHashTable *strtable;

int seen(unsigned h) {
  unsigned bit = (1 << (h & 31));
  unsigned word = (h >> 5);
  if (ht[word] & bit) return 1;
  else {
    ht[word] |= bit;
    return 0;
  }
}

void output(const char *str) {
  if (!g_hash_table_lookup(strtable, str)) {
    puts(str);
    gchar *s = g_string_chunk_insert(strings, str);
    g_hash_table_insert(strtable, s, s);
  }
}

int main() {
  ht = calloc(1<<27, sizeof(unsigned));
  strings = g_string_chunk_new(1024);
  strtable = g_hash_table_new(g_str_hash, g_str_equal);
  unsigned r[24];
  foreach_int(i, 0, 23) {
    r[i] = (unsigned) rand();
  }
  unsigned lines = 0;
  foreach_line(buf, NULL) {
    if (++lines % 100000 == 0) fprintf(stderr, ".");
    buf[12] = 'X';
    foreach_int(i, 13, 22) {
      int c = buf[i];
      if (isupper(c))
	buf[i] = tolower(c);
    }
    foreach_int(a, 2, 12) {
      unsigned h = 0;
      foreach_int(i, a, 12)
	h += (unsigned) buf[i] * r[i];
      foreach_int(b, 13, 23) {
	/* include a, exclude b */
	if (seen(h)) {
	  int c = buf[b];
	  buf[b] = 0;
	  output(buf + a);
	  buf[b] = c;
	}
	if (buf[b-1] == '_') break;
	h += (unsigned) buf[b] * r[b];
      }
    }
  }
}
