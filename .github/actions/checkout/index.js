const exec = require('@actions/exec');

async function run() {
  await exec.exec('git', ['clone', process.env.GITHUB_REPOSITORY, '.']);
}

run();
