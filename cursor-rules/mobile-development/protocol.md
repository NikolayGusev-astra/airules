# 📱 Mobile Development Protocol for Cursor

## 📖 Описание

Протокол для мобильной разработки с Cursor AI. Поддерживает React Native, Flutter и нативную разработку.

## 🎯 Сферы применения

- React Native приложений (iOS + Android)
- Flutter приложений
- Кроссплатформенные решения
- Мобильные UI компоненты

## 🔄 Рабочий процесс

### ФАЗА 1: Mobile Architect (Планирование)

Действуй как Senior Mobile Architect.

#### Задачи:
1. Проектирование навигационной структуры
2. Определение component hierarchy
3. Выбор state management (Redux, Context, Riverpod)
4. Дизайн offline-first архитектуры
5. Определение platform-specific компонентов

#### Ограничения (STRICT):
- ❌ НЕ пиши код в этой фазе
- ❌ НЕ создавай файлы
- ✅ Только архитектурное проектирование

#### Выход (Deliverables):
```markdown
# Архитектура: [Feature Name]

## Navigation Structure
- Tab Navigation: [tabs]
- Stack Navigation: [screens]
- Modal flows: [flows]

## Component Hierarchy
```
src/
  screens/
    [Screen1].tsx
    [Screen2].tsx
  components/
    [Component1].tsx
    [Component2].tsx
  navigation/
    [Navigation].tsx
  store/
    [slice].ts
  services/
    [api].ts
```

## State Management
- Global: [Redux Toolkit/Zustand]
- Local: [useState/useReducer]
- Server state: [React Query]

## Platform-Specific
iOS: [specifics]
Android: [specifics]
```

### ФАЗА 2: Mobile Developer (Выполнение)

Действуй как Mobile Developer.

#### Твой стек (STRICT):
```yaml
React Native:
  - React Native 0.72+
  - TypeScript strict mode
  - Expo SDK 50+ (если используется)
  - React Navigation 6+

State:
  - Redux Toolkit для complex state
  - Zustand для medium complexity
  - Context для simple state
  
Data:
  - React Query для data fetching
  - AsyncStorage для persistence
  
Styling:
  - StyleSheet API (native)
  - React Native Paper / NativeBase (если в проекте)
  
Testing:
  - React Native Testing Library
  - Detox для E2E
```

#### Запрещено (STRICT):
```yaml
❌ Web-specific APIs (window, document)
❌ CSS-in-JS (StyleSheet только)
❌ Platform-specific без проверки Platform.OS
❌ Blocking operations на UI thread
❌ Deeply nested View components (>10 levels)
```

#### Правила разработки:

1. **Структура экрана:**
```tsx
// 1. Imports
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

// 2. Types/Interfaces
interface ScreenProps {
  route: RouteProp<...>;
  navigation: NavigationProp<...>;
}

// 3. Constants/Hooks
const SCREEN_NAME = 'ScreenName';

// 4. Component
export const ScreenName: React.FC<ScreenProps> = ({ route, navigation }) => {
  // hooks
  // handlers
  // effects
  
  return (
    <View style={styles.container}>
      {/* content */}
    </View>
  );
};

// 5. Styles
const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

// 6. Export
export default ScreenName;
```

2. **Platform-specific код:**
```tsx
import { Platform, StyleSheet } from 'react-native';

// ✅ Правильно
const styles = StyleSheet.create({
  button: {
    ...Platform.select({
      ios: {
        padding: 16,
      },
      android: {
        padding: 12,
      },
    }),
  },
});

// ❌ Неправильно (без проверки)
const styles = StyleSheet.create({
  button: {
    padding: 16, // может быть неоптимально для Android
  },
});
```

3. **Performance:**
```tsx
// ✅ Правильно
const MemoizedListItem = React.memo(({ item }: Props) => {
  return <ListItem item={item} />;
}, (prev, next) => prev.item.id === next.item.id);

// ✅ FlatList вместо ScrollView для больших списков
<FlatList
  data={items}
  renderItem={renderItem}
  keyExtractor={(item) => item.id}
  removeClippedSubviews={true}
  maxToRenderPerBatch={10}
  windowSize={10}
/>

// ❌ Неправильно
{items.map((item) => <ListItem key={item.id} item={item} />)}
// Проблема: все item ререндерятся при любом изменении
```

4. **Accessibility:**
```tsx
// ✅ Правильно
<TouchableOpacity
  onPress={handlePress}
  accessible={true}
  accessibilityLabel="Go to settings"
  accessibilityRole="button"
  accessibilityHint="Navigates to settings screen"
>
  <Text>Settings</Text>
</TouchableOpacity>

// ❌ Неправильно
<View onPress={handlePress}> // не accessible
  <Text>Settings</Text>
</View>
```

#### Чеклист перед завершением:
- [ ] Нет web-specific API (window/document)
- [ ] Platform-specific код проверен
- [ ] Используются производительные паттерны (FlatList, React.memo)
- [ ] Accessibility добавлен для всех интерактивных элементов
- [ ] SafeAreaView для статусбара
- [ ] Loading states обработаны
- [ ] Error states обработаны
- [ ] Offline scenarios учтены

### ФАЗА 3: Mobile Validator (Проверка)

Действуй как Mobile Code Reviewer.

#### Проверка платформы:
```typescript
// ❌ FAIL если:
- window.document
- localStorage (вместо AsyncStorage)
- CSS стили (вместо StyleSheet)
- Web-specific libraries
```

#### Проверка производительности:
```typescript
// ❌ FAIL если:
- Map вместо FlatList для больших списков
- Ререндер без React.memo где нужно
- Blocking operations в render
- Глубокая вложенность (>10 levels)
```

#### Проверка безопасности:
```typescript
// ❌ FAIL если:
- API ключи в коде
- Вывод sensitive data в logs
- Небезопасное хранение данных (вместо SecureStore)
```

#### Формат результата:

**ЕСЛИ ОШИБКА:**
```markdown
⛔ VALIDATION FAILED

Причина: [Конкретная проблема]
Файл: [filename.tsx]
Платформа: [iOS/Android/Both]

Нарушение:
- [Rule that was violated]
- [Specific constraint from protocol.md]

Действие: Исправить код, соблюдая протокол

Возврат к ФАЗЕ 2
```

**ЕСЛИ ВСЁ OK:**
```markdown
✅ VALIDATION PASSED

Проверено:
- ✅ No web-specific APIs
- ✅ Platform best practices
- ✅ Performance optimizations
- ✅ Accessibility compliance
- ✅ Security standards

Задача выполнена корректно.
```

## 📋 Примеры использования

### Пример 1: Создание List Screen

**Запрос:**
> Создай экран UserList с FlatList и pull-to-refresh

**Architect Output:**
```markdown
# Архитектура: UserList Screen

## Navigation
Stack screen in Users stack

## Structure
```
screens/users/UserListScreen.tsx
components/UserListItem.tsx
hooks/useUsers.ts
types/user.ts
```

## Data Flow
Screen → useUsers hook → API → React Query → FlatList

## Features
- FlatList with memoized items
- Pull-to-refresh (onRefresh)
- Loading states (header/footer)
- Error handling
- Item navigation (press → detail screen)
```

**Developer Code:**
```tsx
import React from 'react';
import {
  View,
  Text,
  FlatList,
  StyleSheet,
  RefreshControl,
  ActivityIndicator,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useQuery } from '@tanstack/react-query';
import { UserListItem } from '@/components/UserListItem';

interface User {
  id: string;
  name: string;
  email: string;
}

export const UserListScreen = () => {
  const navigation = useNavigation();
  
  const { 
    data: users = [], 
    isLoading, 
    refetch,
    isRefetching 
  } = useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers,
  });

  const renderUser = React.memo(({ item }: { item: User }) => {
    return (
      <UserListItem
        user={item}
        onPress={() => navigation.navigate('UserDetail', { userId: item.id })}
      />
    );
  });

  const keyExtractor = (item: User) => item.id;

  const ListEmptyComponent = () => (
    <View style={styles.emptyContainer}>
      <Text style={styles.emptyText}>No users found</Text>
    </View>
  );

  const ListHeaderComponent = isLoading ? (
    <View style={styles.headerContainer}>
      <ActivityIndicator />
    </View>
  ) : null;

  return (
    <View style={styles.container}>
      <FlatList
        data={users}
        renderItem={renderUser}
        keyExtractor={keyExtractor}
        ListEmptyComponent={ListEmptyComponent}
        ListHeaderComponent={ListHeaderComponent}
        refreshControl={
          <RefreshControl
            refreshing={isRefetching}
            onRefresh={refetch}
          />
        }
        removeClippedSubviews={true}
        maxToRenderPerBatch={10}
        windowSize={10}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  emptyText: {
    fontSize: 16,
    color: '#666',
  },
  headerContainer: {
    padding: 20,
  },
});

export default UserListScreen;
```

**Validator:**
```markdown
✅ VALIDATION PASSED

Проверено:
- ✅ No web-specific APIs
- ✅ FlatList used for performance
- ✅ React.memo for items
- ✅ Pull-to-refresh implemented
- ✅ Loading/error states handled
- ✅ Performance optimizations (removeClippedSubviews, etc.)
```

### Пример 2: Platform-specific Button

**Запрос:**
> Создай кнопку которая выглядит по-разному на iOS и Android

**Architect Output:**
```markdown
# Архитектура: Platform Button

## Component
- Single file: components/ui/PlatformButton.tsx
- Uses Platform API for differences

## iOS Design
- TouchableOpacity
- Default Apple blue color
- iOS 7+ appearance

## Android Design
- Ripple effect
- Material Design colors
- Android API 21+
```

**Developer Code:**
```tsx
import React from 'react';
import {
  TouchableOpacity,
  Text,
  StyleSheet,
  Platform,
  TouchableNativeFeedback,
  View,
  ActivityIndicator,
} from 'react-native';

interface ButtonProps {
  title: string;
  onPress: () => void;
  variant?: 'primary' | 'secondary';
  loading?: boolean;
  disabled?: boolean;
}

export const PlatformButton: React.FC<ButtonProps> = ({
  title,
  onPress,
  variant = 'primary',
  loading = false,
  disabled = false,
}) => {
  const ButtonContent = (
    <View
      style={[
        styles.button,
        variant === 'primary' && styles.buttonPrimary,
        variant === 'secondary' && styles.buttonSecondary,
        disabled && styles.buttonDisabled,
      ]}
    >
      {loading ? (
        <ActivityIndicator
          color={variant === 'primary' ? '#fff' : '#000'}
        />
      ) : (
        <Text
          style={[
            styles.text,
            variant === 'primary' && styles.textPrimary,
            variant === 'secondary' && styles.textSecondary,
          ]}
        >
          {title}
        </Text>
      )}
    </View>
  );

  if (Platform.OS === 'android') {
    return (
      <TouchableNativeFeedback
        onPress={onPress}
        disabled={disabled || loading}
        background={TouchableNativeFeedback.Ripple('#00000033', false)}
      >
        <View>{ButtonContent}</View>
      </TouchableNativeFeedback>
    );
  }

  return (
    <TouchableOpacity
      onPress={onPress}
      disabled={disabled || loading}
      activeOpacity={0.7}
    >
      {ButtonContent}
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  button: {
    padding: 16,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 48,
    ...Platform.select({
      ios: {
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
      },
      android: {
        elevation: 2,
      },
    }),
  },
  buttonPrimary: {
    backgroundColor: Platform.select({
      ios: '#007AFF',
      android: '#6200EE',
    }),
  },
  buttonSecondary: {
    backgroundColor: '#F5F5F5',
  },
  buttonDisabled: {
    opacity: 0.5,
  },
  text: {
    fontSize: 16,
    fontWeight: '600',
  },
  textPrimary: {
    color: '#FFFFFF',
  },
  textSecondary: {
    color: '#000000',
  },
});

export default PlatformButton;
```

---

## 🚀 Частые сценарии

### S1: Создание нового экрана

1. **Architect:** Проектируй навигацию и структуру
2. **Developer:** Реализуй экран
3. **Validator:** Проверь UI/UX и производительность

### S2: Добавление нативных модулей

1. **Architect:** Определи требования к native bridge
2. **Developer:** Реализуй native module wrapper
3. **Validator:** Проверь threading и memory management

### S3: Оптимизация производительности

1. **Architect:** Проанализируй производительность, найди bottlenecks
2. **Developer:** Примени оптимизации
3. **Validator:** Убедись в улучшении через profiling

---

## 📚 Связанные материалы

- [Mobile Architect Role](./roles/architect.md)
- [Mobile Developer Role](./roles/developer.md)
- [Mobile Validator Role](./roles/validator.md)
- [Cursor Rules README](../README.md)
