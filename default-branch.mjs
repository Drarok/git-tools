import { promises as fs } from "fs";

const { HOME } = process.env;

const CONFIG_ROOT = `${HOME}/.config/git-tools`;
const CONFIG_PATH = `${CONFIG_ROOT}/default-branch.json`;

async function loadConfig() {
  try {
    const contents = await fs.readFile(CONFIG_PATH, 'utf-8');
    return JSON.parse(contents);
  } catch (error) {
    if (error.code === 'ENOENT') {
      return {};
    } else {
      throw error;
    }
  }
}

async function saveConfig(config) {
  await fs.mkdir(CONFIG_ROOT, { recursive: true });
  await fs.writeFile(CONFIG_PATH, JSON.stringify(config, null, 2), 'utf-8');
}

function help() {
  console.log("USAGE\n");
  console.log("node default-branch.mjs <path> set <branch>");
  console.log("node default-branch.mjs <path> [get]");
  console.log("node default-branch.mjs <path> rm");
}

function formatRepoPath(path) {
  if (path.startsWith(HOME)) {
    return "~" + path.slice(HOME.length);
  } else {
    return path;
  }
}

async function getDefaultBranch(config, repoName) {
  console.log(config[repoName] || "main");
}

async function setDefaultBranch(config, repoName, branch) {
  config[repoName] = branch;
  await saveConfig(config);
  console.log(`Set default branch for ${formatRepoPath(repoName)} to ${branch}`);
}

async function rmDefaultBranch(config, repoName) {
  delete config[repoName];
  await saveConfig(config);
  console.log(`Removed default branch for ${formatRepoPath(repoName)}`);
}

async function main() {
  if (!HOME) {
    throw new Error("HOME environment variable is not set");
  }

  const config = await loadConfig();
  const args = process.argv.slice(2);

  if (args.length === 3) {
    const [repo, command, branch] = args;
    if (command !== "set") {
      throw new Error("Invalid parameters, only 'set' command accepts 3");
    }
    await setDefaultBranch(config, repo, branch);
  } else if (args.length === 2) {
    const [repo, command] = args;
    switch (command) {
      case "get":
        await getDefaultBranch(config, repo);
        break;
      case "rm":
          await rmDefaultBranch(config, repo);
          break;
      default:
        throw new Error(`Invalid command: ${command}`);
    }
  } else if (args.length === 1) {
    await getDefaultBranch(config, args[0]);
  } else if (arguments.length === 0) {
    help();
  } else {
    throw new Error(`Invalid parameters: ${args}`)
  }
}

try {
  await main();
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
