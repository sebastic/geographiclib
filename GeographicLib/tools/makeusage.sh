#! /bin/sh
# Convert a pod file into a usage function.
# $Id$

SOURCE=$1
BASE=`basename $SOURCE .pod`

cat<<EOF
int usage(int retval, bool brief) {
  if (brief)
    ( retval ? std::cerr : std::cout ) << "Usage:\n\\
EOF

pod2man $SOURCE | nroff -man | col -b -x |
sed -e 1,/SYNOPSIS/d -e '/^$/,$d' -e 's/  / /g' -e 's/$/\\n\\/' -e 's/"/\\"/g'

cat <<EOF
\n\\
For full documentation type:\n\\
    $BASE --help\n\\
or visit:\n\\
    http://geographiclib.sf.net/html/$BASE.1.html\n";
  else
    ( retval ? std::cerr : std::cout ) << "Man page:\n\\
EOF

pod2man $SOURCE | nroff -man | col -b -x | head --lines -4 | tail --lines +5 |
sed -e 's/$/\\n\\/' -e 's/"/\\"/g'

cat <<EOF
";
    return retval;
}
EOF