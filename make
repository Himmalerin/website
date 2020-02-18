#!/bin/sh -e
#
# Simple static site builder.

cat <<EOF > /tmp/meow
<!doctype html><html lang=en><link href='data:image/gif;base64,R0lGODlhEAAQAPH/AAAAAP8AAP8AN////yH5BAUAAAQALAAAAAAQABAAAAM2SLrc/jA+QBUFM2iqA2bAMHSktwCCWJIYEIyvKLOuJt+wV69ry5cfwu7WCVp2RSPoUpE4n4sEADs=' rel=icon><title>KISS</title><meta charset=utf-8><meta name=viewport content="width=device-width,initial-scale=1.0"><meta name=Description content="An independent Linux® distribution with a focus on simplicity and the concept of less is more."><style>body{text-align:center;overflow-y:scroll;font:16px monospace}pre{text-align:left;display:inline-block}a{max-width:70ch;white-space:pre-wrap}img{max-width:57ch;display:block;height:auto;width:100%}@media(prefers-color-scheme:dark){body{background:#000;color:#fff}a{color:#6CF}}</style><pre>
<a href=/><b>KISS</b></a><span style='color:#e60000'> 💋</span>  <a href=/news>News</a>  <a href=/blog>Blog</a>  <a href=/install>Install KISS</a>  <a href=https://github.com/kisslinux/wiki/wiki>Wiki</a>  <a href=/team>Team</a>

<a href=/scrots>Screenshots</a>  <a href=/package-system>Package System</a>  <a href=/testimonials>Testimonials</a>  <a href=/style>Style</a>

<a href=/projects>Software</a>  <a href=/guidestones>Guidestones</a>  <a href=https://github.com/kisslinux/>GitHub</a>  <a href=/contact>Contact</a>  <a href=/donate>Donate</a>


%%CONTENT%%


The registered trademark Linux(R) is used pursuant to a
sublicense from the Linux Foundation, the exclusive
licensee of Linus Torvalds, owner of the mark on a
world­wide basis.

(C) Dylan Araps 2019-2020

</pre>
EOF

rm    -f  docs/*.txt docs/*.html
mkdir -p  docs
cd        docs

# Iterate over each file in the source tree under /site/.
(cd ../site; find . -type f \
        -a -not -path '*/\.*' \
        -a -not -path './templates/*') |

while read -r page; do
    mkdir -p "${page%/*}"

    case $page in
        *.txt)
            sed -E "s|([^=][^\'\"])(https[:]//[^ )]*)|\1<a href='\2'>\2</a>|g" \
                "../site/$page" |

            sed -E "s|^(https[:]//[^ )]{50})([^ )]*)|<a href='\0'>\1</a>|g" |
            sed '/%%CONTENT%%/r /dev/stdin' /tmp/meow |
            sed '/%%CONTENT%%/d' > "${page%%.txt}.html"

            cp -f "../site/$page" "$page"

            printf '%s\n' "CC $page"
        ;;

        # Copy over any images or non-txt files.
        *)
            cp "../site/$page" "$page"

            printf '%s\n' "CP $page"
        ;;
    esac
done
