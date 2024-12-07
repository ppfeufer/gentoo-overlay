# Portage Repository "ppfeufer-gentoo-overlay"<a name="portage-repository-ppfeufer-gentoo-overlay"></a>

______________________________________________________________________

<!-- mdformat-toc start --slug=github --maxlevel=6 --minlevel=2 -->

- [Add this repository](#add-this-repository)
  - [Using `eselect-repository`](#using-eselect-repository)
  - [Using `layman`](#using-layman)
- [Packages](#packages)

<!-- mdformat-toc end -->

______________________________________________________________________

This is an unofficial and privately maintained repository for
[Portage](https://wiki.gentoo.org/wiki/Project:Portage), the
package manager of [Gentoo Linux](https://gentoo.org/).

All ebuilds in this overlay are privately maintained and not
officially supported by the Gentoo portage maintainer team.

> **Note**
>
> Ebuilds I no longer use might be deleted.

## Add this repository<a name="add-this-repository"></a>

### Using `eselect-repository`<a name="using-eselect-repository"></a>

See [eselect-repository]

```bash
eselect repository enable ppfeufer-gentoo-overlay
```

### Using `layman`<a name="using-layman"></a>

See [layman]

```bash
layman -fa ppfeufer-gentoo-overlay
```

## Packages<a name="packages"></a>

| Package                | URL                                                                                    |
| :--------------------- | :------------------------------------------------------------------------------------- |
| app-admin/enpass       | [https://www.enpass.io/](https://www.enpass.io/)                                       |
| dev-vcs/github-desktop | [https://desktop.github.com/](https://desktop.github.com/)                             |
| dev-vcs/gitkraken      | [https://www.gitkraken.com/](https://www.gitkraken.com/)                               |
| net-misc/insync        | [https://www.insynchq.com/](https://www.insynchq.com/)                                 |
| sys-boot/rpi-imager    | [https://github.com/raspberrypi/rpi-imager](https://github.com/raspberrypi/rpi-imager) |
| sys-boot/usbimager     | [https://gitlab.com/bztsrc/usbimager](https://gitlab.com/bztsrc/usbimager)             |
| sys-boot/ventoy-bin    | [https://www.ventoy.net/en/index.html](https://www.ventoy.net/en/index.html)           |

<!-- Links -->

[eselect-repository]: https://wiki.gentoo.org/wiki/Eselect/Repository "Gentoo Wiki: Eselect/Repository"
[layman]: https://wiki.gentoo.org/wiki/Layman "Gentoo Wiki: Layman"
