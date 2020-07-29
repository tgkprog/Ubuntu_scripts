# ls -t will list all files by modified time. But how can I limit these results to only the last n files?

ls -1t | head -5

ls -1t | tail -5

ls -lht | head -6
