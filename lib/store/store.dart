import 'package:flutter_audio_converter/store/player/player_actions.dart';
import 'package:flutter_audio_converter/store/player/player_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';


final Reducer<PlayerState> reducers = combineReducers<PlayerState>([
  new TypedReducer<PlayerState, PlayAction>(playerReducer),
  new TypedReducer<PlayerState, PauseAction>(playerReducer)
]);

final store = new Store<PlayerState>(
  reducers,
  initialState: PlayerState.initialState(),
  middleware: [thunkMiddleware]
);