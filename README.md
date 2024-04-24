# NeuroAI
Looking at LFP data from mice.
## Team members:
- Karim Ghabra
- Chris Carmichael
- Elizabeth Kakachyan
- Edward O'Keefe
- Coby Bowman
- Steven
- Loïc Mas

# Git Tutorial

## Good practices and "rules"
In this project every dataset analysed will have it's own colab notebook associated with it.
For proper workflow and readability, features should be implemented as functions in libraries to be imported in the Colab notebook.
Try as much as possible to work in your own directory and not to touch other people's code

## Basic Workflow
"Inspired from J. Vybihal lectures(c), 2023 in the Course COMP206 at McGill"

0. **Pulling**: At the beginning of the day, it's important to check that nobody has made changes to your files, therefore you must pull from the shared repository. If you are beginning implementing a new feature, do not forget to create a branch for your implementation.
1. **Saving your work**: Usually, Colab saves changes automatically on your own account. 
2. **Committing**: Commmit regularity when working so that you have checkpoints to come back to in case of issues. A good rule of thumb is "whenever you stop working to go to class or to go eat something, it's a god idea to commit"
3. **Pushing**: At the end of the day, when you're done working, push your local branch to the server(i.e. Github).
4. **Merging**: When you're ready to share your work with others, merge your branch with the main by following the procedure.
### How to Branch
It will be better to all work on our seperate branch when implementing a feature, then merging when it is functional.  
As a general rule, never commit to the main branch, even if it's just a small bug.  
- **Branch creation**: At the beginning, when starting to implement something, use the command *!git branch <new_branch_name>* to create the branch.  
- **Moving between branches**: Then, you can move to that branch by using *!git checkout <branch_name>* or do it in one step using *!git branch -b <new_branch_name>*.
- **Listing branches and checking which branch you're on**: *!git branch*, all branches are listes, and your current branch will be highlighted in green.

### How to pull
*__First step before starting your work session.__*
*!git pull*

### How to commit
When you are working on your project, git is not made aware of what you do unless you tell it. In order to tell it which files you modified, there are two steps.
1. First, use the *!git add yourfiles.ipynb* command to add them to the 'Staging box'. At this point your files are behind the scenes, ready to come into the light, but you can still modify them because they are not made public.
2. If you decide to modify staged files, you need to add them again after modifying them (by using !git add <files> or !git add -u, which will automatically know which files were modified and will *update* them)
3. Once satisfied with your modifications, use *!git commit -m 'A very important message'*. This will officialize your changes a create a record of what you did. It is very important that you explain what you did because the commit are encrypted, and so the only way to know what it was for is through this message.
### How to push
*!git push* (right after your last commit, logically)
### How to Branch and merge
When you are ready to merge, follow these steps:
1. Tell the team you're proceeding to a merge, so that they don't touch the repo while it's happening, which could corrupt it (very bad).
2. Use *!git merge <branch_name>*. This can only happen from the branch into which "branch_name" is merging, i.e. think of it as you pulling the branch you want to merge to your current branch. For example, if you want to merge Croissant_honhon to main, you need first *!git checkout main*, then *!git merge Croissant_honhon* to merge it to main.
3. **Delete merged branch**: *!git branch -d <branch_name>* (If you got a wrecked branch, you can delete it without merging it with *!git branch -D <branch_name>*, but be careful with that, there's no ctrl+z.
4. **To exit a branch**: *!git checkout master (or main or origin, depends)*

> PRE-MERGE CHECKS (From Git documentation, https://git-scm.com/docs/git-merge)
Before applying outside changes, you should get your own work in good shape and committed locally, so it will not be clobbered if there are conflicts. See also git-stash[1]. git pull and git merge will stop without doing anything when local uncommitted changes overlap with files that git pull/git merge may need to update.
To avoid recording unrelated changes in the merge commit, git pull and git merge will also abort if there are any changes registered in the index relative to the HEAD commit. (Special narrow exceptions to this rule may exist depending on which merge strategy is in use, but generally, the index must match HEAD.)
If all named commits are already ancestors of HEAD, git merge will exit early with the message "Already up to date."}

### How to come back to a previous version or undo something
* **To undo a commit (but not a merge)**: !git checkout -f
* **To go back after breaking the code**:
  + *!git log* to see commit history and find \<SHA\>, which looks like 'kiagcbii8n2c48n745ctm7x4m5xt2oy8t52x80m83t' and is the ID of the commit
  + *!git checkout \<SHA\>*

n.B. I think there it is possible to merge an earlier version if the code broke after a given commit, but I have to verify

### Useful stuff 
* **Check discrepancies between files**: *!git diff* (all files compared with current) or *!git diff file_1* (compares tip file with current file), useful to know which files to add/commit
* **Check status of the repo**: i.e. are there any new files which haven't been added to the staging box/commited 

# How to Stream Data from a dataset into the colab notebook
