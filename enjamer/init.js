import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

function installCli() {
  if (process.platform !== 'linux' && process.platform !== 'win32') {
    console.error(`Enjamer CLI installation is unavailable on ${process.platform}.`);
    return 1;
  }

  const isWindows = process.platform === 'win32';
  const installer = fileURLToPath(
    new URL(isWindows ? './cli/scripts/install.ps1' : './cli/scripts/install.sh', import.meta.url),
  );
  const command = isWindows ? 'powershell.exe' : 'sh';
  const args = isWindows
    ? ['-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'Bypass', '-File', installer]
    : [installer];

  const result = spawnSync(command, args, { stdio: 'inherit' });
  if (result.error) {
    console.error(`Unable to run the Enjamer CLI installer: ${result.error.message}`);
  }
  return result.status ?? 1;
}

process.exitCode = installCli();
