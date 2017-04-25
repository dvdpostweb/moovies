jwplayer("myElement").setup({
    "file": "https://d2jl6e4h8300i8.cloudfront.net/drm/dash/netflix_meridian/mbr/stream.mpd",
    "playlist": [
        {
            "sources": [
                {
                    "file": "https://d2jl6e4h8300i8.cloudfront.net/drm/dash/Sintel/stream.mpd",
                    "drm": {
                        "widevine": {
                            "url": "https://wv-keyos.licensekeyserver.com/",
                            "headers": [
                                {
                                    "name": "customData",
                                    "value": "PD94bWwgdmVyc2lvbj0iMS4wIj8+CjxLZXlPU0F1dGhlbnRpY2F0aW9uWE1MPjxEYXRhPjxXaWRldmluZVBvbGljeSBmbF9DYW5QZXJzaXN0PSJmYWxzZSIgZmxfQ2FuUGxheT0idHJ1ZSIvPjxXaWRldmluZUNvbnRlbnRLZXlTcGVjIFRyYWNrVHlwZT0iSEQiPjxTZWN1cml0eUxldmVsPjE8L1NlY3VyaXR5TGV2ZWw+PC9XaWRldmluZUNvbnRlbnRLZXlTcGVjPjxMaWNlbnNlIHR5cGU9InNpbXBsZSIvPjxHZW5lcmF0aW9uVGltZT4yMDE3LTA0LTIwIDE4OjQ5OjUwLjAwMDwvR2VuZXJhdGlvblRpbWU+PEV4cGlyYXRpb25UaW1lPjIwMjctMDQtMjAgMTk6MDk6NTAuMDAwPC9FeHBpcmF0aW9uVGltZT48VW5pcXVlSWQ+YTE1ODYyNDllM2E5ZTY3YmRhYzRjZWI1NTgxZjlkZjA8L1VuaXF1ZUlkPjxSU0FQdWJLZXlJZD5kZjQwODc5MjY3ZmEyZmFlODE4YTlhM2JhN2E3MGViMjwvUlNBUHViS2V5SWQ+PC9EYXRhPjxTaWduYXR1cmU+bWNDWDM4QjlNelRla0hSZFd4Z215bXUxbWVSQ1BPbVUyS2JwYm5saWtBTkZaNzhwMG8vMEV0a1ZTODRlWHV3blBuOUUxQTd6eVkwa0pMT3FkUlVvRDZCVDhUb3RnQ3hZZG51dEVPRVgwaG1CZjh2MW54OFhJV0FyWUhya2hEWDZ0d01valNnSWJpZk95Mnp6dy81RTBLeTg1YWVMVVZiYktnZ3V2bFFhZHdzejJpQXhkaUNiWFgyUG82Q0NYUXlEbTRCK1VzWEpDcFl6Q3N5ZjdYRUkxYjM2MWZtK1VmV1pvV0wvc0VsQWZzN29zbk9SUmg4cTdnRCtqZmpWSDR1KzAxRU9FYk1KWTlMN1FhSkFjWUJjeFRVOXlKcEYvZDNPWlR1YlhpWjllTVpSZGlKR1VzYnZwRWplV0l4Wk9RVExVNWtXZXJJNUY5cmx4SSs4cW81aUZRPT08L1NpZ25hdHVyZT48L0tleU9TQXV0aGVudGljYXRpb25YTUw+Cg=="
                                }
                            ]
                        }
                    }
                }
            ]
        }
    ],
    "primary": "html5",
    "hlshtml": true
});