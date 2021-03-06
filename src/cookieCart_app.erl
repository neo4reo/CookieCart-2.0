%% @hidden
-module (cookieCart_app).
-include_lib ("nitrogen/include/wf.inc").
-compile(export_all).

%%% APPLICATION FUNCTIONS %%%

start(_, _) -> 
    db:start(),
    nitrogen:start().
stop(_) -> nitrogen:stop().
	
%% route/1 lets you define new URL routes to your web pages, 
%% or completely create a new routing scheme.
%% The 'Path' argument specifies the request path. Your
%% function should return either an atom which is the page module
%% to run, or a tuple containing {Module, PathInfo}. PathInfo
%% can be accessed using wf:get_path_info(). 
%%
%% Uncomment the line below to direct requests 
%% from "/web/newroute" to the web_index module:
%%
%% route("/web/newroute") -> web_index;
%%
%% Uncomment the line below to direct requests 
%% from "/web/newroute" to the web_index module, 
%% with trailing PathInfo included:
%%
%% route("/web/newroute/" ++ PathInfo) -> {web_index, PathInfo};

route(Path=("/web/admin/"++_)) -> nitrogen:route(Path);
route("/web/" ++ PathInfo) -> {web_index,PathInfo};
route(Path) -> nitrogen:route(Path).


%% request/1 is executed before every Nitrogen page, and lets
%% you add authentication and authorization. The 'Module' argument
%% is the name of the page module.
%% This function should return either 'ok' if processing can proceed,
%% or it can return a full-fledged page by treating it just like the main function
%% of a page. Alternatively, you can use the wf:redirect* functions to 
%% issue a client-side redirect to a new page.


request(Module) ->
    ProtectedPages = [web_postwork,web_PM,web_privchat],
    
    case lists:member(Module,ProtectedPages) of
 	false ->
 	    nitrogen:request(Module);
 	true ->
 	    case wf:user() of
 		undefined ->
 		    wf:redirect_to_login("/web/login");
 		_->
 		    ok
 	    end
    end.

%request(Module) ->
%    nitrogen:request(Module).

% Code for testing basic authentication:
%
% request(Module) -> 
% 	wf_http_basic_auth:run(Module, ?MODULE).
% 	
% realm() -> "nitrogen".
% 
% is_authenticated(Module, _) -> false.
% 
% authenticate(Module, User, Password) ->
% 	User == "Rusty" andalso Password == "password".ubuntu@ubuntu:/usr/local/lib/erlang/lib/nitrogen-master/Quickstart/src$ 

