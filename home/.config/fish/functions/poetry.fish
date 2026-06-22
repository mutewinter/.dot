function __fish_poetry
    for i in (commandline -opc)
        if contains -- $i about add build cache check config debug env export help init install lock new publish remove run search self shell show update version
            return 1
        end
    end
    return 0
end
