# pkgbuild-to-signed-repo Github Action
This action will build all PKGBUILDs inside of the `repos/` folder within the github repository, turn the resulting packages into a signed pacman repo, and then release it as a github release.

## Obtaining the GPG key
If you do not have a GPG key to use, you can generate one by using `gpg --full-generate-key`. Select `RSA and RSA` as the kind of key you can, and make sure not to enter a passphrase.

Once you have obtained the key to use, the key id will be listed. Example: `6078CB28FECF9CB449FA4958B8AD94D01C6A0712`

To obtain the private key used as the `gpg_key_data` input, run `gpg --export-secret-keys --armor <key_id>`. This will print the full private key into your terminal.

> [!IMPORTANT]
>
> DO NOT give the private key to anybody, or let it leak at any point in your action. If this happens, your key is now compromised. It can be used by anybody to sign files and packages, and you will have to generate a new one.
>
> For this reason, it is advised for you to generate a key specifically made for use with your repository.
>
> In order to keep the private key from leaking out in the action, create a repository secret in your repository's `Settings > Secrets and Variables > Actions` called "GPG_KEY_DATA", paste the contents of `gpg --export-secret-keys --armor <key_id>` into the `Secret` textbox, and hit `Add secret`.
>
> Your public key `gpg_key_id`, on the other hand, should be shared, as it is what people will use to ensure that packages from your repository truly do come from you.

## Inputs

### repo_name
**required** The name of the repo that is generated.

### gpg_key_id
**required** The public fingerprint of the GPG key used to validate the packages in the repository.

### gpg_key_data
**required** The private GPG key used to sign the packages in the repository.

### github_token
**required** The token used to manage github releases.

## Usage Example

```yaml
- name: Build & Push to GitHub Releases
  id: build
  uses: hecknt/pkgbuild-to-signed-repo@v0.1.0
  with:
    repo_name: "repository"
    github_token: "${{ secrets.GITHUB_TOKEN }}"
    gpg_key_data: "${{ secrets.GPG_KEY_DATA }}"
    gpg_key_id: "${{ vars.GPG_KEY_ID }}"
```
