function txt2clip
    set folder $argv[1]
    set output ""
    for file in $folder/*.txt
        set filename (basename $file .txt)
        set content (cat $file)
        set output "$output\n### $filename\n$content\n"
    end
    echo -e $output | pbcopy
end
