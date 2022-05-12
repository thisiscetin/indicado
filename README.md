## Indicado 🚀🌕

<p>
  <a href="https://hex.pm/packages/indicado">
    <img alt="Hex Version" src="https://img.shields.io/hexpm/v/indicado.svg">
  </a>
  <a href="https://hexdocs.pm/indicado">
    <img alt="Hex Docs" src="http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat">
  </a>
    <a href="https://github.com/thisiscetin/indicado/actions">
    <img alt="CI Status" src="https://github.com/thisiscetin/indicado/workflows/ci/badge.svg">
  </a>
  <a href="https://opensource.org/licenses/Apache-2.0">
    <img alt="Apache 2 License" src="https://img.shields.io/hexpm/l/oban">
  </a>
</p>

[Technical indicator](https://www.investopedia.com/terms/t/technicalindicator.asp) library for Elixir with no dependencies. Indicado helps you analyze historical data to generate future price movement predictions on numerical datasets. Many traders and automated trading platforms use technical analysis because past actions may indicate future prices. Indicado might also be used outside financial markets if data hold patterns and not random.

## What can you do with this library ❔

This library can be used as an add-on to [Kamil Skorwon's](https://twitter.com/kamilskowron) great project [Hands-on Elixir & OTP: Cryptocurrency trading bot](https://www.elixircryptobot.com), at some point. So, you can create sophisticated trading strategies that may better fit your risk appetite. You can also use this library for your custom solutions around automated trading/testing/strategy building.

In the future, in addition to supporting the community, [I](https://twitter.com/thisiscetin) plan to release more open source tools around strategy building, backtesting, and numerical analysis.


## Table of Contents 📋
- [Indicado](#indicado-)
- [What can you do with this library](#what-can-you-do-with-this-library-)
- [Table of Contents](#table-of-contents-)
- [Supported Indicators](#supported-indicators-)
- [Installation](#installation-)
- [Usage](#usage-️)
- [Contributing](#contributing-)

## Supported Indicators 📈
Indicators below are supported. New indicators being added regularly.
- Accumulation/Distribution Line ([ADI](https://www.investopedia.com/terms/a/accumulationdistribution.asp))
- Bollinger Bands ([BB](https://www.investopedia.com/terms/b/bollingerbands.asp))
- Exponential Moving Average ([EMA](https://www.investopedia.com/terms/e/ema.asp))
- Money Flow Index ([MFI](https://www.investopedia.com/terms/m/mfi.asp))
- Moving Average Convergence Divergence ([MACD](https://www.investopedia.com/terms/m/macd.asp))
- On-Balance Volume ([OBV](https://www.investopedia.com/terms/o/onbalancevolume.asp))
- Relative Strength Index ([RSI](https://www.investopedia.com/terms/r/rsi.asp))
- Simple Moving Average ([SMA](https://www.investopedia.com/terms/s/sma.asp))
- Stochastic Oscillator ([SR](https://www.investopedia.com/terms/s/stochasticoscillator.asp))
- Williams %R ([WR](https://www.investopedia.com/terms/w/williamsr.asp))

Helper math functions such as mean, stddev, variance is accessible through `Indicado.Math` module.

## Installation 💻

Indicado published to [Hex](https://hex.pm/packages/indicado). Just add it to your dependencies in `mix.exs`.

```elixir
def deps do
  [
    {:indicado, "~> 0.0.4"}
  ]
end
```
Then run `mix deps.get` to install indicado.

## Usage 🛠️

Indicado provides two functions on the public API of indicators. Namely `eval` and `eval!` function.
- `eval` function calls return `{:ok, result}` or `{:error, reason}`.
- `eval!` functions return a single result list or raises exceptions such as `NotEnoughDataError`.

Because every other indicator may expect different arguments, I recommend you check [online documentation on hexdocs](https://hexdocs.pm/indicado/Indicado.html) before using the indicado. For demonstration purposes how you can calculate a two day Simple Moving Average is shown below.

```elixir
  iex(2)> Indicado.SMA.eval([1, 3, 5, 7], 2)
  {:ok, [2.0, 4.0, 6.0]}
```

## Contributing 🧵

Please follow standard convention such as `eval` and `eval!` functions defined for all indicators inside `lib` folder.
Rest is easy;

- Fork it!
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create new Pull Request

To ensure a commit passes CI run `mix test.ci` before opening a pull request to execute commands below.
