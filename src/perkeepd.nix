{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.perkeepd;

  perkeepServerJSON = pkgs.writeText "perkeep-server.json" ''
    {
      "auth": "${cfg.auth}",
      ${optionalString (cfg.baseURL != null) "\"baseURL\": \"${cfg.baseURL}\","}
      "https": ${if cfg.https then "true" else "false"},
      ${optionalString (cfg.httpsCert != null) "\"httpsCert\": \"${cfg.httpsCert}\","}
      ${optionalString (cfg.httpsKey != null) "\"httpsKey\": \"${cfg.httpsKey}\","}
      ${optionalString (cfg.camliNetIP != null) "\"camliNetIP\": \"${cfg.camliNetIP}\","}
      ${optionalString (cfg.identity != null) "\"identity\": \"${cfg.identity}\","}
      ${optionalString (cfg.identitySecretRing != null) "\"identitySecretRing\": \"${cfg.identitySecretRing}\","}
      "shareHandler": ${if cfg.shareHandler then "true" else "false"},
      ${optionalString (cfg.shareHandlerPath != null) "\"shareHandlerPath\": \"${cfg.shareHandlerPath}\","}
      "runIndex": ${if cfg.runIndex then "true" else "false"},
      "copyIndexToMemory": ${if cfg.copyIndexToMemory then "true" else "false"},
      ${optionalString (cfg.sourceRoot != null) "\"sourceRoot\": \"${cfg.sourceRoot}\","}

      "memoryStorage": ${if cfg.memoryStorage then "true" else "false"},
      ${optionalString (cfg.blobPath != null) "\"blobPath\": \"${cfg.blobPath}\","}
      ${optionalString (cfg.s3 != null) "\"s3\": \"${cfg.s3}\","}
      ${optionalString (cfg.b2 != null) "\"b2\": \"${cfg.b2}\","}
      ${optionalString (cfg.googlecloudstorage != null) "\"googlecloudstorage\": \"${cfg.googlecloudstorage}\","}

      "packRelated": ${if cfg.packRelated then "true" else "false"},
      "packBlobs": ${if cfg.packBlobs then "true" else "false"},

      ${optionalString (cfg.sqlite != null) "\"sqlite\": \"${cfg.sqlite}\","}
      ${optionalString (cfg.kvIndexFile != null) "\"kvIndexFile\": \"${cfg.kvIndexFile}\","}
      ${optionalString (cfg.levelDB != null) "\"levelDB\": \"${cfg.levelDB}\","}
      ${optionalString (cfg.mongo != null) "\"mongo\": \"${cfg.mongo}\","}
      ${optionalString (cfg.mysql != null) "\"mysql\": \"${cfg.mysql}\","}
      ${optionalString (cfg.postgres != null) "\"postgres\": \"${cfg.postgres}\","}
      "memoryIndex": ${if cfg.memoryIndex then "true" else "false"},

      ${optionalString (cfg.dbname != null) "\"dbname\": \"${cfg.dbname}\","}
      ${optionalString (cfg.dbUnique != null) "\"dbUnique\": \"${cfg.dbUnique}\","}

      "listen": "${cfg.listen}"
    }
  '';
in
{
  options = {
    services.perkeepd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable perkeep server (perkeepd)
        '';
      };

      auth = mkOption {
        type = types.str;
        description = ''
          the authentication mechanism to use. Example values include:

          none: No authentication.

          localhost: Accept connections coming from localhost. On Linux, this
          means connections from localhost that are also from the same user as
          the user running the server.

          userpass:alice:secret: HTTP basic authentication. Username “alice”,
          password “secret”. Only recommended if using HTTPS.

          userpass:alice:secret:+localhost: Same as above, but also accept
          localhost auth

          userpass:alice:secret:vivify=othersecret: Alice has password
          “secret”, but her Android phone can use password “othersecret” to do
          a minimal set of operations (upload new things, but not access
          anything).
        '';
      };

      baseURL = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          If non-empty, this is the root of your URL prefix for your Perkeep
          server. Useful for when running behind a reverse proxy. Should not
          end in a slash. e.g. https://yourserver.example.com
        '';
      };

      https = mkOption {
        type = types.bool;
        default = false;
        description = ''
          if true, HTTPS is used.

          If an explicit certificate and key are not provided, a certificate
          from Let’s Encrypt is requested automatically if the following
          conditions apply:

          A fully qualified domain name is specified in either baseURL or
          listen.  Perkeep listens on port 443 in order to answer the TLS-SNI
          challenge from Let’s Encrypt.

          As a fallback, if no FQDN is found, a self-signed certificate is
          generated.
        '';
      };

      httpsCert = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          path to the HTTPS certificate file. This is the public file. It
          should include the concatenation of any required intermediate certs
          as well.
        '';
      };

      httpsKey = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          path to the HTTPS private key file.
        '';
      };

      camliNetIP = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          the optional internet-facing IP address for this Perkeep instance. If
          set, a name in the camlistore.net domain for that IP address will be
          requested on startup. The obtained domain name will then be used as
          the host name in the base URL. For now, the protocol to get the name
          requires receiving a challenge on port 443. Also, this option implies
          https, and that the HTTPS certificate is obtained from Let’s Encrypt.
          For these reasons, this option is mutually exclusive with baseURL,
          listen, httpsCert, and httpsKey. On cloud instances (Google Compute
          Engine only for now), this option is automatically used.
        '';
      };

      identity = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          your GPG fingerprint. A keypair is created for new users on start,
          but this may be changed if you know what you’re doing.
        '';
      };

      identitySecretRing = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          your GnuPG secret keyring file. A new keyring is created on start for
          new users, but may be changed if you know what you’re doing.
        '';
      };

      listen = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The port (like "80" or ":80") or IP:port (like "10.0.0.2:8080") to
          listen for HTTP(s) connections on.
        '';
      };

      shareHandler = mkOption {
        type = types.bool;
        default = false;
        description = ''
          if true, the server’s sharing functionality is enabled, letting your
          friends have access to any content you’ve specifically shared. Its
          URL prefix path defaults to "/share/".
        '';
      };

      shareHandlerPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        description =  ''
          If non-empty, it specifies the URL prefix path to the share handler,
          and the shareHandler value is ignored (i.e the share handler is
          enabled). Example: "/public/".
        '';
      };

      runIndex = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If false, no search, no UI, no indexing. (These can be controlled at
          a more granular level by writing a low-level config file)
        '';
      };

      copyIndexToMemory = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If false, don’t slurp the whole index into memory on start-up.
          Specifying false will result in certain queries being slow,
          unavailable, or unsorted (work in progress). This option may be
          unsupported in the future. Keeping this set to true is recommended.
        '';
      };

      sourceRoot = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          If non-empty, it specifies the path to an alternative Perkeep source
          tree, in order to override the embedded UI and/or Closure resources.
          The UI files will be expected in $sourceRoot/server/perkeepd/ui and
          the Closure library in $sourceRoot/third_party/closure/lib.
        '';
      };

      memoryStorage = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Turns on the memoryStorage storage backend.

          if true, blobs will be stored in memory only. This is generally only
          useful for debugging and development.
        '';
      };

      blobPath = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Turns on the blobPath storage backend.

          local disk path to store blobs. (valid for diskpacked too).
        '';
      };

      packRelated = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Only relevant if blobPath is set.

          if true, blobs are automatically repacked for fast read access.
        '';
      };

      packBlobs = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Only relevant if blobPath is set.

          if true, diskpacked is used instead of the default filestorage.
        '';
      };

      s3 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Turns on the s3 storage backend.

          “key:secret:bucket[/optional/dir]” or
          “key:secret:bucket[/optional/dir]:hostname” (with colons, but no
          quotes).

          The hostname value may be set to use an S3-compatible endpoint
          instead of AWS S3, such as my-minio-server.example.com. A specific
          region may be specified by using Low-level Configuration, though the
          bucket’s region will generally be detected automatically.
        '';
      };

      b2 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Turns on the b2 storage backend.

          “account_id:application_key:bucket[/optional/dir]”.
        '';
      };

      googlecloudstorage = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Turns on the googlecloudstorage storage backend.

          “clientId:clientSecret:refreshToken:bucketName[/optional/dir]”
        '';
      };

      sqlite = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          If runIndex is set, exactly one of {sqlite, kvIndexFile, levelDB,
          mongo, mysql, postgres, memoryIndex} must be set.

          path to SQLite database file to use for indexing
        '';
      };

      kvIndexFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          If runIndex is set, exactly one of {sqlite, kvIndexFile, levelDB,
          mongo, mysql, postgres, memoryIndex} must be set.

          path to kv (https://github.com/cznic/kv) database file to use for
          indexing
        '';
      };

      levelDB = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          If runIndex is set, exactly one of {sqlite, kvIndexFile, levelDB,
          mongo, mysql, postgres, memoryIndex} must be set.

          path to levelDB (https://github.com/syndtr/goleveldb) database file
          to use for indexing
        '';
      };

      mongo = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          If runIndex is set, exactly one of {sqlite, kvIndexFile, levelDB,
          mongo, mysql, postgres, memoryIndex} must be set.

          user:password@host
        '';
      };

      mysql = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          If runIndex is set, exactly one of {sqlite, kvIndexFile, levelDB,
          mongo, mysql, postgres, memoryIndex} must be set.

          user@host:password
        '';
      };

      postgres = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          If runIndex is set, exactly one of {sqlite, kvIndexFile, levelDB,
          mongo, mysql, postgres, memoryIndex} must be set.

          user@host:password
        '';
      };

      memoryIndex = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If runIndex is set, exactly one of {sqlite, kvIndexFile, levelDB,
          mongo, mysql, postgres, memoryIndex} must be set.

          if true, a memory-only indexer is used.
        '';
      };


      dbname = mkOption {
        type = types.nullOr types.str;
        default = null;
        description =  ''
          optional name of the index database if MySQL, PostgreSQL, or MongoDB,
          is used. If empty, dbUnique is used as part of the database name.
        '';
      };

      dbUnique = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          optionally provides a unique value to differentiate databases on a
          DBMS shared by multiple Perkeep instances. It should not contain
          spaces or punctuation. If empty, identity is used instead. If the
          latter is absent, the current username (provided by the operating
          system) is used instead. For the index database, dbname takes
          priority.
        '';
      };

      # Note: Publish and ScanCab nodes aren't implemented.
      #   https://perkeep.org/pkg/types/serverconfig/

    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.perkeep pkgs.libjpeg ];

    systemd.services.perkeepd = {
      description = "perkeep server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.perkeep pkgs.libjpeg ];

      serviceConfig = {
        ExecStart = "${pkgs.perkeep}/bin/perkeepd -configfile ${perkeepServerJSON}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
      };
    };
  };
}
