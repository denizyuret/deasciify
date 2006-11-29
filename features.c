#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <glib.h>
FILE *popen(const char *command, const char *type);
int pclose(FILE *stream);
#include "foreach.h"

GStringChunk *strings = NULL;
GHashTable *strtable = NULL;

int main(int argc, char **argv) {
  unsigned lines = 0;
  if (argc > 1) {		/* we have a feature list */
    fputs("Reading features\n", stderr);
    strings = g_string_chunk_new(1024);
    strtable = g_hash_table_new(g_str_hash, g_str_equal);
    char cmd[256];
    snprintf(cmd, 256, "|zcat %s", argv[1]);
    foreach_line(buf, cmd) {
      if (++lines % 100000 == 0) fprintf(stderr, ".");
      buf[strlen(buf)-1] = 0;
      gchar *s = g_string_chunk_insert(strings, buf);
      g_hash_table_insert(strtable, s, s);
    }
  }
  fputs("\nReading instances\n", stderr);
  lines = 0;
  foreach_line(buf, NULL) {
    if (++lines % 100000 == 0) fprintf(stderr, ".");
    buf[12] = 'X';
    foreach_int(i, 13, 22) {	/* lowercase right side */
      int c = buf[i];
      if (isupper(c))
	buf[i] = tolower(c);
    }
    putchar(*buf);		/* class */
    foreach_int(a, 2, 12) {
      foreach_int(b, 13, 23) {
	/* include a, exclude b */
	int c = buf[b];
	buf[b] = 0;
	gchar *s = buf + a;
	if ((NULL == strtable) ||
	    g_hash_table_lookup(strtable, s)) {
	  putchar(' ');
	  fputs(s, stdout);
	}
	buf[b] = c;
	if (buf[b-1] == '_') break;
      }
    }
    putchar('\n');
  }
}
