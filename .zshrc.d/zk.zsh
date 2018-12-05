# # Zettelkasten shortcuts.
# # DYNALIST_API_TOKEN is defined in ~/.bash/secrets.bash (git ignored)
# zk-raw() {
#   local token
#   token="$(security find-generic-password -w -l dynalist-token)"
#   curl -s -XPOST -d "{\"token\": \"${token}\", \"file_id\": \"Vys54zOGRMkMlgHHZLAbRyya\"}'" \
#     https://dynalist.io/api/v1/doc/read
# }

# zk() {
#  zk-raw | jq -r '.nodes | .[] | .content, .note, ""'
# }

# zk-ratings() {
#   zk | rg "#pw" | rg "#u(\d+).+#u(\d+)" -o -r '$1 -> $2'
# }

# zk-unreviewed() {
#   zk-raw | jq ".nodes | .[] | select(.note | test(\"&review-\") | not) "
# }

# zk-count() {
#   zk-raw | jq ".nodes | length"
# }

# zk-check-dups() {
#   zk | rg "^\d+\. " -o | sort | uniq -cd
# }

# zk-check-review-format() {
#   zk-raw | jq -r ".nodes | .[] .note" | rg -o "&review-\d+" | rg -v "\d{10}"
# }

# zk-check-title-format() {
#   zk-raw | jq -r ".nodes | .[] | .content" | tail -n +2 | rg -v "\d{10}+\. [\w\s[[:punct:]]]+ \(.+\)"
# }

# zk-check-date-format() {
#   zk | rg -o "\d{10}" | \
#   rb -l "n = Time.strptime(self, '%y%m%d%H%M'); \
#     (n < Time.strptime('2016', '%Y') || n > Time.strptime('2020', '%y')) && self" | \
#   rg -v false
# }

# zk-tags() {
#   zk | rg -o "#[\w\-_]+" | rg -v "#(u|r)\d+" | rg -v "#p(w|i)" | sort | uniq -c | sort -r
# }

# zk-check-format() {
#   zk-check-review-format
#   zk-check-title-format
#   zk-check-date-format
# }

# zk-check-length() {
#   zk-raw | rb '\
#     from_json[:nodes][1..-1].select { |n|
#       n[:word_length] = n[:note].split("\n").reject { |l|
#         l =~ /\A(!|#|\\#|&|\[|>)/ || l.empty?
#       }.join.split.size
#       n[:word_length] > 80
#     }.each { |n|
#       puts "VIOLATES LENGTH... #{n[:word_length]}/80"
#       puts n[:content]
#       puts n[:note]
#       puts
#     }; nil
#   '
# }

# # TODO:
# # - if using keywords, check that some don't have too many, or too few?
# # - check for sparse # tags?
# zk-check() {
#   zk-check-dups
#   zk-check-format
#   zk-check-length
# }

# # TODO:
# # - zk-bidirectional-links. make sure A->B also has B->A link.
# # - zk-review. cloze deletion? base it on #u and #r.
# # - zk-import. import from readwise..?
# # - zk-review-tag. fzf to select a tag.
# # - zk-review-connect. try to connect with others.
# # - zk-pictures. percentage?
# # - zk-prune. take low U and consider deleting them.
