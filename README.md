# ya-provider

It installs [yagna](https://github.com/golemfactory/yagna/) provider with [wasi](https://github.com/golemfactory/ya-runtime-wasi/) and [vm](https://github.com/golemfactory/ya-runtime-vm/) runtimes.

Services are installed withouth using root as systemd user services, running as `ansible_user`.

Tasks that require root are in separate file `tasks/system_setup.yml`.


## Requirements

### Systemd

Target system must use systemd >= 230.

It's possible to use older systemd version, but user lingering must be manually enabled with `sudo loginctl enable-linger username`.


### KVM

VM runtime requires access to `/dev/kvm` and working acceleration. Required steps to configure acces are in `tasks/system_setup.yml`.

Note: It's possible to disable vm runtime, by removing it from `ya_provider_presets_active`.


## Role Variables

### defaults

Releases:
- `ya_provider_yagna_package_prefix`: What name of yagna release package file starts with.
- `ya_provider_yagna_version`: Tag of yagna release.
- `ya_provider_yagna_url`: Url to yagna release tarball. For testing purposes can be changed to `file://` path.
- `ya_provider_wasi_version`: Tag of wasi runtime release.
- `ya_provider_wasi_url`: Url to wasi runtime release tarball.
- `ya_provider_vm_version`: Tag of vm runtime release.
- `ya_provider_vm_url`: Url to wasi runtime tarball.

Promtail:
- `ya_provider_use_promtail`: Enables usage of promtail [boolean].
- `ya_provider_promtail_version`: Tag of loki/promtail release.
- `ya_provider_promtail_url`: Url to promtail release zip.
- `ya_provider_loki_url`: Url where promtail should send logs. If promtail is enabled, it must be set to something.

Yagna config:
- `ya_provider_rust_log`: Log level.
- `ya_provider_gsb_url`: Address, where yagna should listen for GSB connections.
- `ya_provider_yagna_api_url`: Address, where yagna should listen for API connections.

Ya-provider config:
- `ya_provider_name`: Your fancy name for others in the network to see.
- `ya_provider_subnet`: Subnet. See [provider tutorial](https://handbook.golem.network/provider-tutorials/provider-tutorial).
- `ya_provider_payment_network_group`: Payment network group: `testnet` or `mainnet`.
- `ya_provider_hardware`: How much resources should yagna use. If not specified, yagna uses internal logic to pick some sane defaults. Format: `{cpu_threads: int, mem_gib: int, storage_gib: int}`.
- `ya_provider_presets_active`: List of runtimes to install.
- `ya_provider_presets_usage_coeffs`: Pricing. See [provider docs # Offer formulation](https://github.com/golemfactory/yagna/tree/master/agent/provider#offer-formulation). Format: `{cpu: float [GLM/sec], duration: float [GLM/sec], initial: float [GLM]}`.
- `ya_provider_account`: Address to collect income to. Format: `"0x..."` (quotes around "0x..." are important, because otherwise ansible converts it into decimal number). Optional, although encouraged, when running on mainnet payment network.

Stopping (`tasks/stop.yml`):
- `ya_provider_stop_purge`: Purge yagna datadir [boolean].


### vars

- `ya_provider_subnet_dir`: Directory, where all config and runtime files are kept.
- `ya_provider_releases_dir`: Directory for unpacking release binaries.
- `ya_provider_unit_name`: Systemd unit name for yagna service.
- `ya_provider_yagna_dir`: Path to unpacked yagna binaries.
- `ya_provider_promtail_dir`: Directory with unpacked promtail binary.
- `ya_provider_promtail_bin`: Path to promtail binary.


## Dependencies

None


## Example Playbook

    - hosts: all
      tasks:
        # only this uses "become" for privilege escalation
        - import_role:
            name: golemfactory.ya_provider
            tasks_from: system_setup

    - hosts: all
      vars:
        ya_provider_name: Your fancy name
        ya_provider_subnet: public-beta
        ya_provider_payment_network: mainnet
        ya_provider_hardware:
          cpu_threads: 4
          mem_gib: 2
          storage_gib: 10
        ya_provider_presets_usage_coeffs:
          cpu: 0.0001
          duration: 0.00005
          initial: 0.0
        ya_provider_account: "0xYourEthereumAddress"
      roles:
         - golemfactory.ya_provider


## License

GPL-3.0-or-later


## Author Information

[Golem Network](https://golem.network/)
