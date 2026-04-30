# GOOGLE HACKING CHEAT SHEET
## ADVANCED QUERYING

| Query | Description & Example |
| :--- | :--- |
| `inurl:` | Value is contained somewhere in the url.<br>Ex: `"preventing ransomware inurl:fbi"` |
| `site:` | Only search within this website's given domain<br>Ex: `"windows xp end of life site:microsoft.com"` |
| `filetype:` | Search only for files, not webpages<br>Ex: `"nasa moon landing filetype:JPG"` |
| `allinurl:` | Search all of the following words in the url.<br>Ex: `allinurl: "blog wordpress" information security` |
| `intext:` | Search the body of the webpage for specific text.<br>Ex: `patient record intext:"index of /htdocs"` |
| `related:` | Find website results that are related to your search term.<br>Ex: `related:sans.org` |
| `info:` | Find supplemental information Google may have on this page (useful for finding cached pages)<br>Ex: `info:www.usgs.gov` |
| `link:` | Find other pages indexed by Google that reference this link<br>Ex: `link:http://www.somecompany.com/supersecretfile.doc` |
| `"quote"` | Find an exact phrase (though results may include related words)<br>Ex: `"Malware Hunting"` |
| `+word` | Show results with this word exactly. Do not include similar words.<br>Ex: `Malware +Hunter` |
| `-word/query` | Do not include this word in search results or queries.<br>Ex: `Advanced Malware Hunting -beginner -introduction -site:microsoft.com` |
| `"word * word"` | Wildcard. Search for anything between these two words, but include both.<br>Ex: `"Next * Firewalls with *"` |
| `OR` (or `|`) | Return results for either item. The pipe character can be used in place<br>Ex: `"locky OR ransomware"`; Ex: `"locky | ransomware"` |
| `AND` (or `&`) | Return results with both items. Ampersand character can be used in place.<br>Ex: `"cissp AND certification"` Ex: `"cissp & certification"` |

> Remember, the real power comes in stringing multiple advanced operators together.
> `("Index Of" | "[To Parent Directory]") AND ""financ"" inbody:xlsx site:somebank.com`