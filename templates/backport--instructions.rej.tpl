Backport of PR #${number} to branch ${target} failed

${url}

<% if (missing > 0) { %>
- ${missing} file<%- missing !== 1 ? 's' : '' %> could not be found in this branch
<% } %>
- ${failed} patch<%- failed !== 1 ? 'es' : '' %> failed to apply
- ${succeeded} patch<%- succeeded !== 1 ? 'es were' : ' was' %> applied successfully

-------------------------------------

At this point, you need to manually resolve these conflicts on your machine and
push the changes back up to this upstream branch so the PR is updated with your
changes. The following instructions and scripts should help with that.

All of the provided scripts assume that the remote "upstream" is where the
backport branch exists and that your local branch has the exact same name as
the upstream branch.

First, check out this branch locally:

  git fetch upstream ${branch}
  git checkout ${branch}

Now, just follow one of these two paths:


1. GUIDED BACKPORT

You should do the guided backport if you want to apply the backported changes
while resolving the conflicts on each commit. For most cases, this is what you
want to do.

The following script will rebase the commits that need to be backported onto
a new temporary branch. Resolve any conflicts as you normally would during a
rebase. Do not remove these backport-*.rej files, and feel free to add
additional commits if that's necessary:

    sh backport-guided-begin.rej

Once the conficts are resolved and the rebase is completed, the following
script will update the local backport branch with the changes, remove the
temporary branch that was created, remove the remnants of this backport commit
and squash the newly resolved commits (and any others you may have added) into
a single backport commit with the proper commit message:

    sh backport-guided-finish.rej

At this point, you should be on the local backport branch, and it should be
exactly 1 commit ahead of the intended target. The commit message should be
very similar if not identical to the PR itself, and the changeset should
include all of the changes you intended to backport and none of these
backport-*.rej files.

Now just replace the contents of the pull request with your local changes:

    git push -f upstream ${branch}


2. ALMOST COMPLETELY MANUAL

You should do this option if there are just so many conflicts that it's easier
to rebuild the entire changeset from scratch. You'll still work on the local
backport branch which should be up to date with the intended target.

Feel free to add as many commits as you'd like and don't worry about fancy
commit messages - we're just going to squash them down and replace the message
when you're finished.

Once the changes are committed on your local backport branch, the following
script will remove the remnants of this backport commit and squash the newly
created commits into a single backport commit with the proper commit message.

    sh backport-wrangle-into-commit.rej

At this point, you should be on the local backport branch, and it should be
exactly 1 commit ahead of the intended target. The commit message should be
very similar if not identical to the PR itself, and the changeset should
include all of the changes you intended to backport and none of these
backport-*.rej files.

Now just replace the contents of the pull request with your local changes:

    git push -f upstream ${branch}
