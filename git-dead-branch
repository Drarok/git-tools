#!/usr/bin/env php
<?php

$arguments = array_slice($argv, 1);

if (in_array('--help', $arguments) || in_array('-h', $arguments)) {
    echo 'NAME', PHP_EOL;
    echo '    git-dead-branch - List/delete branches that are contained in develop/master, or a specified branch.', PHP_EOL;
    echo PHP_EOL;
    echo 'SYNOPSIS', PHP_EOL;
    echo '    git-dead-branch [-a] [-c] [-f] [branch] […]', PHP_EOL;
    echo PHP_EOL;
    echo 'OPTIONS', PHP_EOL;
    echo PHP_EOL;
    echo '    -h, --help', PHP_EOL;
    echo '        This help text.', PHP_EOL;
    echo PHP_EOL;
    echo '    -a, --all', PHP_EOL;
    echo '        Include remote branches.', PHP_EOL;
    echo PHP_EOL;
    echo '    -c, --cleanup', PHP_EOL;
    echo '        Automatically delete redundant branches.', PHP_EOL;
    echo PHP_EOL;
    echo '    -f, --force', PHP_EOL;
    echo '        Forces deletion of redundant branches.', PHP_EOL;
    echo PHP_EOL;
    echo '    [branch]', PHP_EOL;
    echo '        Names of the branches to consider "safe". Defaults to develop and master.', PHP_EOL;
    return;
}

// Parse arguments.
$allBranches = in_array('--all', $arguments) || in_array('-a', $arguments);
$cleanup = in_array('--cleanup', $arguments) || in_array('-c', $arguments);
$force = in_array('--force', $arguments) || in_array('-f', $arguments);

// Get the branches.
if ($allBranches) {
    $branches = explode(PHP_EOL, rtrim(shell_exec('git branch -a')));
    $branches = array_filter($branches, function ($branch) {
        return strpos($branch, '->') === false;
    });
} else {
    $branches = explode(PHP_EOL, rtrim(shell_exec('git branch')));
}

$safeBranches = array_filter($arguments, function ($arg) {
    return strlen($arg) > 0 && $arg[0] != '-';
});

if (count($safeBranches) === 0) {
    $safeBranches = ['develop', 'master'];
}

$safeBranchesPattern = implode('|', array_map(function ($branch) {
    return preg_quote($branch, '/');
}, $safeBranches));


define('DEVELOP_MASTER_PATTERN', '/^(remotes\/[^\/]+\/)?(develop|master)$/');
define('SAFE_PATTERN', '/^(remotes\/[^\/]+\/)?('.$safeBranchesPattern.')$/');

$deadBranches = array();
foreach ($branches as $branch) {
    // Remove leading '* ' or '  '.
    $branch = substr($branch, 2);

    // Always ignore local and remote develop and master.
    if (preg_match(DEVELOP_MASTER_PATTERN, $branch)) {
        continue;
    }

    // Ignore the safe branches (same as above if user has specified no branches).
    if (preg_match(SAFE_PATTERN, $branch)) {
        continue;
    }

    $containingBranchesCommand = 'git branch -a --contains ' . escapeshellarg($branch);

    $containingBranches = array_map(
        function ($b) {
            // Remove leading '* ' or '  '.
            return substr($b, 2);
        },
        explode(PHP_EOL, rtrim(shell_exec($containingBranchesCommand)))
    );

    foreach ($containingBranches as $containingBranch) {
        if (preg_match(SAFE_PATTERN, $containingBranch)) {
            $deadBranches[] = $branch;
            break;
        }
    }
}

if (!$deadBranches) {
    echo 'There are no dead branches.', PHP_EOL;
} else {
    if ($allBranches && $cleanup) {
        echo 'Cleaning up remote branches is not currently supported.', PHP_EOL;
        $cleanup = false;
    }

    foreach ($deadBranches as $branch) {
        if ($cleanup) {
            $option = $force ? '-D' : '-d';
            echo shell_exec('git branch ' . $option . ' ' . escapeshellarg($branch));
        } else {
            echo $branch, PHP_EOL;
        }
    }
}
