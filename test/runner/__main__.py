import click
from . import get_test_modules, run_test, TestbenchNotFoundError


@click.group()
def cli():
  pass


@cli.command()
@click.argument("testmodules", nargs=-1, required=True)
def run(testmodules):
  """Run the tests provided by argument (can be multiple tests)"""
  all_modules = get_test_modules()

  for tm in testmodules:
    if tm not in all_modules:
      raise click.ClickException(f"'{tm}' is not a valid testmodule")

  for tm in testmodules:
    try:
      run_test(tm)
    except TestbenchNotFoundError as e:
      raise click.ClickException(str(e))


@cli.command()
def list_tests():
  """List all available tests (indexed and adressed by testmodules)"""
  click.echo("Testmodules:")
  for tm in get_test_modules():
    click.echo(f">> {tm}")


if __name__ == "__main__":
  cli()
