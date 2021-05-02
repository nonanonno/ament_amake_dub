#!/usr/bin/env dub
/+ dub.sdl:
  name "make_local_package"
  dependency "dxml" version="~>0.4.3"
+/
import std.stdio;
import dxml.dom;
import std.file;
import std.algorithm : canFind;
import std.json;
import std.conv : to;
import std.process;
import std.array;

void main(string[] args)
{
  new Dub(args[2]).write_local_package(from_package_path().filter(new Package(args[1]).depends()));
}

class Package
{
  this(string filename)
  {
    dom_ = filename.readText.parseDOM!simpleXML();
  }

  string name()
  {
    return parse!"name"();
  }

  string pkg_version()
  {
    return parse!"version"();
  }

  string[] depends()
  {
    assert(dom_.children.length == 1);
    auto pkg = dom_.children[0];
    string[] deps;
    foreach (child; pkg.children)
    {
      if (["depend", "build_depend", "test_depend", "exec_depend"].canFind(child.name))
      {
        assert(child.type == EntityType.elementStart);
        auto text = child.children[0];
        assert(text.type == EntityType.text);
        deps ~= text.text;
      }
    }
    return deps;
  }

private:
  string parse(string item)()
  {
    assert(dom_.children.length == 1);
    auto pkg = dom_.children[0];
    foreach (child; pkg.children)
    {
      if (child.name == item)
      {
        assert(child.type == EntityType.elementStart);
        auto text = child.children[0];
        assert(text.type == EntityType.text);
        return text.text;
      }
    }
    return "";
  }

  DOMEntity!string dom_;
}

class Dub
{
  this(string filename)
  {
    location_ = filename;
    j_ = (filename ~ "/dub.json").readText.parseJSON();
  }

  string name() const
  {
    return j_["name"].str;
  }

  string pkg_version() const
  {
    if ("version" in j_)
    {
      return j_["version"].str;
    }
    else
    {
      return "";
    }
  }

  string[] depends() const
  {
    if ("dependencies" !in j_)
    {
      return [];
    }
    string[] deps;
    foreach (pkg, _; j_["dependencies"].object)
    {
      deps ~= pkg;
    }
    return deps;
  }

  JSONValue to_repo() const
  {
    JSONValue jj = ["name" : name, "path" : location_, "version" : pkg_version];
    return jj;
  }

  void write_local_package(Dub[] dep_dubs)
  {
    JSONValue jj;
    jj.array = [];
    foreach (dub; dep_dubs)
    {
      jj.array ~= dub.to_repo();
    }
    auto str = jj.toJSON(true, JSONOptions.doNotEscapeSlashes);
    mkdirRecurse(location_ ~ "/.dub/packages");
    auto f = File(location_ ~ "/.dub/packages/local-packages.json", "w");
    f.write(str);
  }

private:
  string location_;
  JSONValue j_;
}

Dub[] from_package_path()
{
  auto dub_dirs = environment.get("DUB_PACKAGE_PATH", "").split(':');
  Dub[] dubs;
  foreach (dub; dub_dirs)
  {
    if (exists(dub ~ "/dub.json"))
    {
      dubs ~= new Dub(dub);
    }
  }
  return dubs;
}

Dub[] filter(Dub[] dubs, string[] pkgs)
{
  Dub[] ret;
  foreach (d; dubs)
  {
    foreach (p; pkgs)
    {
      if (d.name == p)
      {
        ret ~= d;
      }
    }
  }
  return ret;
}
