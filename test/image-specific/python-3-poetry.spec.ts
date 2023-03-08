import { runContainer } from '../runContainer';

jest.setTimeout(1000 * 90);

it('can do `w3security test` on a poetry project', async () => {
  const imageName = 'python-3.8';
  const { stdout, stderr } = await runContainer(
    imageName,
    'w3security test',
    './fixtures/python-3-pyproject-toml',
  );

  expect(stdout).toContain('Testing /app...');
  expect(stdout).toContain('poetry-fixtures-project');
  expect(stdout).toContain(
    'Regular Expression Denial of Service (ReDoS) [Medium Severity][https://security.snyk.io/vuln/SNYK-PYTHON-JINJA2-1012994]',
  );
  expect(stderr).toBe(
    'Skipping virtualenv creation, as specified in config file.\n',
  );
});

it('can do `w3security test` on a poetry project with lockfile', async () => {
  const imageName = 'python-3.8';
  const { stdout, stderr } = await runContainer(
    imageName,
    'w3security test',
    './fixtures/python-3-poetry-lock',
  );

  expect(stdout).toContain('Testing /app...');
  expect(stdout).toContain('poetry-fixtures-project');
  expect(stdout).toContain(
    'Regular Expression Denial of Service (ReDoS) [Medium Severity][https://security.snyk.io/vuln/SNYK-PYTHON-JINJA2-1012994]',
  );
  expect(stderr).toBe('');
});
