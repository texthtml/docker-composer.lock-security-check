# Composer CVE check

Docker image that check your PHP dependencies managed by [composer](https://getcomposer.org/) for known vulnerabilities using [security.sensiolabs.org](https://security.sensiolabs.org/check) or [versioneye.com](https://www.versioneye.com).

## Usage

`docker run -v $(pwd)/composer.lock:/scripts/composer.lock:ro texthtml/composer-cve-check`

## Configuration

You can set env var to customize composer-cve-check behavior

* `SENSIOLABS=false`: disable check on sensiolabs.org
* `VERSIONEYE_PROJECT_ID=.......`: [versioneye project id](https://www.versioneye.com/organisations/mathroc/projects) to activate check on versioneye
* `VERSIONEYE_API_KEY=.......`: [your versioneye API key](https://www.versioneye.com/organisations/mathroc/apikey)
