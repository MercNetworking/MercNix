{ ... }:
{
  flake.modules.homeManager.git-gh = { ... }: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Hunter Welch";
          email = "hxnterwelch@proton.me";
        };
      };
    };

    # gh handles GitHub auth end-to-end, including wiring up git's
    # credential helper.
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
