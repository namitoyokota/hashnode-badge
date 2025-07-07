# hashnode-badge
GitHub Actions to display Hashnode statistic as a Shields.io badge.

## Step by step guide

1. Fork this repository.
2. Set `BLOG_HOST` variable `script.sh` with your Hashnode blog URL.
3. Add badge using your GitHub username.
4. In repository settings, **Settings** -> **Actions** -> **General**. Under **Workflow permissions**, toggle `Read and write permissions`.
5. GitHub Actions will automatically be triggered every mid-night (can also be manually triggered).

## Example

```markdown
![Hashnode](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/YOUR_USERNAME/hashnode-badge/main/badge.json)
```

![Hashnode](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/namitoyokota/hashnode-badge/main/badge.json)