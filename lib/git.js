#!/usr/bin/env node
const util = require('util');
const execFile = util.promisify(require('child_process').execFile);

class Git {
  static async localBranches() {
    const prefix = 'refs/heads/';
    const removePrefix = prefix.length;
    const output = await this.#git('for-each-ref', prefix);
    return output
      .split('\n')
      .filter(line => !!line)
      .map(line => {
        const [_, name] = line.split('\t');
        return name.slice(removePrefix);
      });
  }

  static async remoteBranches() {
    const prefix = 'refs/remotes/';
    const removePrefix = 'refs/'.length;
    const output = await this.#git('for-each-ref', prefix);
    return output
      .split('\n')
      .filter(line => !!line && line.slice(-5) !== '/HEAD')
      .map(line => {
        const [_, name] = line.split('\t');
        return name.slice(removePrefix);
      });
  }

  static async allBranchesContaining(branch) {
    const output = await this.#git('branch', '-a', '--contains', branch);
    return output
      .split('\n')
      .filter(line => !!line)
      .map(line => line.slice(2));
  }

  static async deleteBranch(branch, force) {
    const option = force ? '-D' : '-d';
    return this.#git('branch', option, branch);
  }

  static async #git(...args) {
    try {
      const result = await execFile('git', args);
      const { stdout } = result;
      return stdout;
    } catch (e) {
      const { stderr, stdout } = e;
      if (stdout) process.stdout.write(stdout);
      if (stderr) process.stderr.write(stderr);
      throw e;
    }
  }
}

module.exports = Git;
