This is a collection of build and release tasks for VSTS for demo purposes.  This one is a configuration token
swapper.  Given a directory, this task will recursively search for *.token files, will then replace the tokens __TokenName__ with 
the values you've set, and will then copy the file to whatever your * was.