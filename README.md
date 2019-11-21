# gentoo-overlay

My personal Gentoo overlay

### layman
Update laymans overlay list first
```bash
layman -f
```

Add the overlay
```bash
layman -a ppfeufer-gentoo-overlay
```

If that doesn't work for you, try this
```bash
layman -f -o https://raw.githubusercontent.com/ppfeufer/gentoo-overlay/master/ppfeufer-gentoo-overlay.xml -a ppfeufer-gentoo-overlay
```
