:: 7z the folder because otherwise the publish task takes too long for the free azure limit ...

7z a -r -mx4 ../archive.7z ./
dir
dir ..
mv ../archive.7z ./