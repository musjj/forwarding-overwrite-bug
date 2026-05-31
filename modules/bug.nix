{ denTest, ... }:
{
  flake.tests.bogus = {

    test-something = denTest (
      {
        den,
        lib,
        igloo,
        ...
      }:
      let
        atuinClass =
          { class, aspect-chain }:
          den._.forward {
            each = lib.singleton null;
            fromClass = _: "atuin";
            intoClass = _: "nixos";
            intoPath = _: [
              "programs"
              "atuin"
            ];
            fromAspect = _: lib.head aspect-chain;
            guard = _: true;
          };
      in
      {
        den.hosts.x86_64-linux.igloo.users.tux = { };

        den.default.includes = [ den._.mutual-provider ];

        den.aspects.atuin = {
          includes = [
            atuinClass
          ];

          atuin.flags = [
            "--hello"
          ];
        };

        den.aspects.igloo = {
          provides.to-users.includes = [
            den.aspects.atuin
          ];

          atuin.flags = [
            "--world"
            "--baz"
          ];
        };

        expr = lib.sort lib.lessThan igloo.programs.atuin.flags;

        expected = [
          "--baz"
          "--hello"
          "--world"
        ];
      }
    );

  };
}
